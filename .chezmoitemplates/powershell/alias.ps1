# 'Remove-Item Alias:ni -Force -ErrorAction Ignore'
Set-Alias -Name cz -Value chezmoi

# scoop
function scls {scoop list}
function scud {scoop update}
function scuda {scoop update *}
function sccl {scoop cleanup *}
function scst {scoop status}
function scck {scoop checkup}