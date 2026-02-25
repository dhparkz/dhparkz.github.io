param(
  [string]$Title = "",
  [string]$Slug = "",
  [string]$CreatedBy = "blog-main"
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$repoRoot = Split-Path -Parent $root
$tasksRoot = Join-Path $root 'tasks'
New-Item -ItemType Directory -Force -Path $tasksRoot | Out-Null

function Invoke-Git {
  param(
    [string]$Cwd,
    [string[]]$Args
  )
  $output = & git -C $Cwd @Args 2>&1
  if($LASTEXITCODE -ne 0){
    throw "git failed ($($Args -join ' ')): $output"
  }
  return ($output -join "`n").Trim()
}

$taskId = 'BLOG-' + (Get-Date -Format 'yyyyMMdd-HHmmss')
$branch = "feature/draft_$taskId"

# Mandatory branch policy: create/switch to feature/draft_<task_id> before task work.
$branchExists = $true
try {
  Invoke-Git -Cwd $repoRoot -Args @('show-ref','--verify',"refs/heads/$branch") | Out-Null
} catch {
  $branchExists = $false
}

if($branchExists){
  Invoke-Git -Cwd $repoRoot -Args @('checkout',$branch) | Out-Null
} else {
  Invoke-Git -Cwd $repoRoot -Args @('checkout','-b',$branch) | Out-Null
}

$taskDir = Join-Path $tasksRoot $taskId
New-Item -ItemType Directory -Force -Path $taskDir | Out-Null

$files = @('idea.md','plan.md','research.md','draft.md','edit.md','publish_ready.md','published.md')
foreach($f in $files){
  $p = Join-Path $taskDir $f
  if(-not (Test-Path $p)){
    Set-Content -Path $p -Encoding UTF8 -Value "# $f`n`ntask_id: $taskId`n"
  }
}

$state = [ordered]@{
  task_id = $taskId
  title = $Title
  slug = $Slug
  branch = $branch
  state = 'IDEA'
  hop_limit = 5
  created_at = (Get-Date).ToString('o')
  created_by = $CreatedBy
  history = @(
    [ordered]@{
      at = (Get-Date).ToString('o')
      from = $null
      to = 'IDEA'
      reason = 'task created'
      branch = $branch
    }
  )
  idempotency = [ordered]@{
    seen_event_ids = @()
  }
}

$statePath = Join-Path $taskDir 'state.json'
$state | ConvertTo-Json -Depth 8 | Set-Content -Path $statePath -Encoding UTF8

$syncRaw = & (Join-Path $PSScriptRoot 'commit-push-task.ps1') -TaskId $taskId -Message "blog($taskId): initialize task" -Branch $branch
$sync = $syncRaw | ConvertFrom-Json
if(-not $sync.ok){
  throw "initial commit/push failed for $taskId"
}

[ordered]@{
  ok = $true
  task_id = $taskId
  task_dir = $taskDir
  state = 'IDEA'
  branch = $branch
  commit = $sync.commit
  pushed = $sync.pushed
} | ConvertTo-Json -Depth 6
