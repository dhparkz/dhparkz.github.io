param(
  [Parameter(Mandatory=$true)][string]$TaskId,
  [string]$Message = '',
  [string]$Remote = 'origin',
  [string]$Branch = ''
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$repoRoot = Split-Path -Parent $root
$taskDir = Join-Path (Join-Path $root 'tasks') $TaskId
$statePath = Join-Path $taskDir 'state.json'
if(-not (Test-Path $taskDir)){ throw "task directory not found: $taskDir" }

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

$expectedBranch = $Branch
if([string]::IsNullOrWhiteSpace($expectedBranch)){
  if(Test-Path $statePath){
    try {
      $state = Get-Content $statePath -Raw | ConvertFrom-Json
      if($state.branch){ $expectedBranch = [string]$state.branch }
    } catch {}
  }
}
if([string]::IsNullOrWhiteSpace($expectedBranch)){
  $expectedBranch = "feature/draft_$TaskId"
}

$currentBranch = Invoke-Git -Cwd $repoRoot -GitArgs @('rev-parse','--abbrev-ref','HEAD')
if($currentBranch -ne $expectedBranch){
  [ordered]@{
    ok = $false
    error = 'branch_mismatch'
    expected = $expectedBranch
    actual = $currentBranch
  } | ConvertTo-Json -Depth 6
  exit 12
}

$taskRelative = ".openclaw-blog/tasks/$TaskId"
Invoke-Git -Cwd $repoRoot -GitArgs @('add','--',$taskRelative) | Out-Null

$staged = Invoke-Git -Cwd $repoRoot -GitArgs @('diff','--cached','--name-only','--',$taskRelative)
$committed = $false
$commitHash = ''
if(-not [string]::IsNullOrWhiteSpace($staged)){
  $commitMessage = if([string]::IsNullOrWhiteSpace($Message)){ "blog($TaskId): sync task artifacts" } else { $Message }
  Invoke-Git -Cwd $repoRoot -GitArgs @('commit','-m',$commitMessage,'--',$taskRelative) | Out-Null
  $committed = $true
  $commitHash = Invoke-Git -Cwd $repoRoot -GitArgs @('rev-parse','HEAD')
}

# Always push so remote reflects latest branch tip for user interaction.
Invoke-Git -Cwd $repoRoot -GitArgs @('push','-u',$Remote,$expectedBranch) | Out-Null

if(-not $commitHash){
  $commitHash = Invoke-Git -Cwd $repoRoot -GitArgs @('rev-parse','HEAD')
}

[ordered]@{
  ok = $true
  task_id = $TaskId
  branch = $expectedBranch
  committed = $committed
  commit = $commitHash
  pushed = $true
  remote = $Remote
} | ConvertTo-Json -Depth 8

