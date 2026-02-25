param(
  [Parameter(Mandatory=$true)][string]$TaskId,
  [Parameter(Mandatory=$true)][ValidateSet('PLAN','RESEARCHED','DRAFTED','EDITED','PUBLISH_READY','PUBLISHED')][string]$TargetState,
  [string]$Reason = '',
  [string]$EventId = ''
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$repoRoot = Split-Path -Parent $root
$taskDir = Join-Path (Join-Path $root 'tasks') $TaskId
$statePath = Join-Path $taskDir 'state.json'
if(-not (Test-Path $statePath)){ throw "state.json not found: $statePath" }

$state = Get-Content $statePath -Raw | ConvertFrom-Json

function Invoke-Git {
  param(
    [string]$Cwd,
    [string[]]$GitArgs
  )
  $output = & git -C $Cwd @GitArgs 2>&1
  if($LASTEXITCODE -ne 0){
    throw "git failed ($($GitArgs -join ' ')): $output"
  }
  return ($output -join "`n").Trim()
}

$expectedBranch = if($state.branch){ [string]$state.branch } else { "feature/draft_$TaskId" }
$currentBranch = Invoke-Git -Cwd $repoRoot -GitArgs @('rev-parse','--abbrev-ref','HEAD')
if($currentBranch -ne $expectedBranch){
  [ordered]@{ ok=$false; error='branch_mismatch'; expected=$expectedBranch; actual=$currentBranch } | ConvertTo-Json -Depth 6
  exit 12
}

$nextMap = @{
  'IDEA' = 'PLAN'
  'PLAN' = 'RESEARCHED'
  'RESEARCHED' = 'DRAFTED'
  'DRAFTED' = 'EDITED'
  'EDITED' = 'PUBLISH_READY'
  'PUBLISH_READY' = 'PUBLISHED'
}

$current = [string]$state.state
$expected = $nextMap[$current]
if($expected -ne $TargetState){
  [ordered]@{ ok=$false; error='invalid_transition'; current=$current; expected_next=$expected; requested=$TargetState } | ConvertTo-Json -Depth 6
  exit 2
}

if($state.hop_limit -le 0){
  [ordered]@{ ok=$false; error='hop_limit_exceeded'; current=$current } | ConvertTo-Json -Depth 6
  exit 3
}

if(-not $state.idempotency){
  $state | Add-Member -NotePropertyName idempotency -NotePropertyValue ([pscustomobject]@{ seen_event_ids=@() })
}

if($EventId -and $state.idempotency.seen_event_ids -contains $EventId){
  [ordered]@{ ok=$true; duplicate=$true; task_id=$TaskId; state=$current } | ConvertTo-Json -Depth 6
  exit 0
}

$requiredFileByTarget = @{
  'PLAN' = 'plan.md'
  'RESEARCHED' = 'research.md'
  'DRAFTED' = 'draft.md'
  'EDITED' = 'edit.md'
  'PUBLISH_READY' = 'publish_ready.md'
  'PUBLISHED' = 'published.md'
}

$requiredName = $requiredFileByTarget[$TargetState]
$required = Join-Path $taskDir $requiredName
if(-not (Test-Path $required)){
  [ordered]@{ ok=$false; error='missing_output'; required=$required } | ConvertTo-Json -Depth 6
  exit 4
}

$content = (Get-Content $required -Raw).Trim()
if($content.Length -lt 40){
  [ordered]@{ ok=$false; error='output_too_short'; required=$required; min_chars=40 } | ConvertTo-Json -Depth 6
  exit 5
}

function Test-ContainsAll([string]$text, [string[]]$tokens){
  foreach($t in $tokens){
    if($text -notmatch [regex]::Escape($t)){ return $false }
  }
  return $true
}

$shapeOk = $true
switch($TargetState){
  'PLAN' { $shapeOk = Test-ContainsAll $content @('titles:','audience:','intent:','outline:') }
  'RESEARCHED' {
    $shapeOk = Test-ContainsAll $content @('evidence_summary:','competitor_gap:','cliche_warnings:')
    $sidCount = ([regex]::Matches($content,'source_id\s*:\s*')).Count
    if($sidCount -lt 5){ $shapeOk = $false }
  }
  'DRAFTED' { $shapeOk = Test-ContainsAll $content @('sections:','summary:','cta_faq:') }
  'EDITED' { $shapeOk = Test-ContainsAll $content @('diff:','fact_check:','quality_score:') }
  'PUBLISH_READY' { $shapeOk = Test-ContainsAll $content @('front_matter:','slug:','seo_checklist:','distribution_copy:') }
  'PUBLISHED' { $shapeOk = Test-ContainsAll $content @('published_at:','post_url:') }
}

if(-not $shapeOk){
  [ordered]@{ ok=$false; error='output_shape_invalid'; required=$required; target=$TargetState } | ConvertTo-Json -Depth 6
  exit 7
}

if($TargetState -eq 'PUBLISHED'){
  $approvalPath = Join-Path $taskDir 'approval.txt'
  if(-not (Test-Path $approvalPath)){
    [ordered]@{ ok=$false; error='missing_human_approval'; required=$approvalPath } | ConvertTo-Json -Depth 6
    exit 6
  }
}

$requiredRelative = ".openclaw-blog/tasks/$TaskId/$requiredName"

# Enforce commit-after-edit: auto-commit the stage output when it is dirty/untracked.
$dirty = Invoke-Git -Cwd $repoRoot -GitArgs @('status','--porcelain','--',$requiredRelative)
if(-not [string]::IsNullOrWhiteSpace($dirty)){
  try {
    Invoke-Git -Cwd $repoRoot -GitArgs @('add','--',$requiredRelative) | Out-Null
    $commitMessage = "blog($TaskId): $($TargetState.ToLowerInvariant()) output"
    Invoke-Git -Cwd $repoRoot -GitArgs @('commit','-m',$commitMessage,'--',$requiredRelative) | Out-Null
  } catch {
    [ordered]@{
      ok = $false
      error = 'auto_commit_failed'
      required = $required
      branch = $expectedBranch
      details = $_.Exception.Message
    } | ConvertTo-Json -Depth 8
    exit 13
  }
}

$stageCommit = ''
try {
  $stageCommit = Invoke-Git -Cwd $repoRoot -GitArgs @('log','-n','1','--pretty=%H','--',$requiredRelative)
} catch {
  $stageCommit = ''
}

if([string]::IsNullOrWhiteSpace($stageCommit)){
  [ordered]@{
    ok = $false
    error = 'missing_commit_for_output'
    required = $required
    hint = "Commit tracking failed for $requiredRelative. Check .gitignore and branch state."
  } | ConvertTo-Json -Depth 6
  exit 11
}

$from = $current
$state.state = $TargetState
$state.branch = $expectedBranch
$state.hop_limit = [int]$state.hop_limit - 1
if($EventId){ $state.idempotency.seen_event_ids += $EventId }
$state.history += [pscustomobject]@{
  at = (Get-Date).ToString('o')
  from = $from
  to = $TargetState
  reason = $Reason
  branch = $expectedBranch
  commit = $stageCommit
  required_output = $requiredRelative
}

$state | ConvertTo-Json -Depth 12 | Set-Content -Path $statePath -Encoding UTF8

$syncRaw = & (Join-Path $PSScriptRoot 'commit-push-task.ps1') -TaskId $TaskId -Message "blog($TaskId): transition $from -> $TargetState" -Branch $expectedBranch
$sync = $syncRaw | ConvertFrom-Json
if(-not $sync.ok){
  [ordered]@{
    ok = $false
    error = 'push_failed_after_transition'
    task_id = $TaskId
    branch = $expectedBranch
  } | ConvertTo-Json -Depth 6
  exit 14
}

[ordered]@{
  ok = $true
  task_id = $TaskId
  from = $from
  to = $TargetState
  hop_limit = $state.hop_limit
  required_output = $required
  branch = $expectedBranch
  commit = $stageCommit
  pushed = $sync.pushed
  remote_commit = $sync.commit
} | ConvertTo-Json -Depth 8

