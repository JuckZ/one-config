$script_name = $MyInvocation.MyCommand.Name
Write-Host ">>> $script_name is running"

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

try {
  Get-Command bw -ErrorAction Stop
} catch {
  scoop install bitwarden-cli
}

try {
  Get-Command age -ErrorAction Stop
} catch {
  scoop bucket add extras
  scoop install extras/age
}

Write-Host "<<< $script_name finished"