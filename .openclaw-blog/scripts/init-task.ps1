param(
  [string]$Title = "",
  [string]$Slug = "",
  [string]$CreatedBy = "blog-main"
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$tasksRoot = Join-Path $root 'tasks'
New-Item -ItemType Directory -Force -Path $tasksRoot | Out-Null

$taskId = 'BLOG-' + (Get-Date -Format 'yyyyMMdd-HHmmss')
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
    }
  )
  idempotency = [ordered]@{
    seen_event_ids = @()
  }
}

$statePath = Join-Path $taskDir 'state.json'
$state | ConvertTo-Json -Depth 8 | Set-Content -Path $statePath -Encoding UTF8

[ordered]@{
  ok = $true
  task_id = $taskId
  task_dir = $taskDir
  state = 'IDEA'
} | ConvertTo-Json -Depth 6
