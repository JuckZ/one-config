$script_name = $MyInvocation.MyCommand.Name
Write-Host ">>> $script_name is running"
{{ include "../../.chezmoitemplates/powershell/profile.ps1" -}}
Write-Host "<<< $script_name finished"