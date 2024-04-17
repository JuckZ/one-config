$script_name = $MyInvocation.MyCommand.Name
Write-Host ">>> $script_name is running"

scoop bucket add extras
scoop install bitwarden-cli
scoop install extras/age

Write-Host "<<< $script_name finished"