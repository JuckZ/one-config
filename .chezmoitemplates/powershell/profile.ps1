# 'Remove-Item Alias:ni -Force -ErrorAction Ignore'
Set-Alias -Name cz -Value chezmoi

$Env:PROJECT_HOME = "$env:USERPROFILE\Documents\projects"
# set env for komorebi
$Env:KOMOREBI_CONFIG_HOME = "$env:USERPROFILE\.config\komorebi"
$Env:WHKD_CONFIG_HOME = "$env:USERPROFILE\.config\whkd"

$Env:SELF_ELEVATE = "false"
$selfElevate = [System.Convert]::ToBoolean($env:SELF_ELEVATE)
if($selfElevate) {
  # Self-elevate the script if required
  if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
      # you can remove -NoExit from $CommandLine, but then you likely won’t see the output of the elevated script, which will make it more difficult to determine if something went wrong during its execution.
      $CommandLine = "-NoExit -File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
      Start-Process -Wait -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
      Exit
    }
  }
}

function Test-IsInteractive {
  $nonInteractiveParameters = @(
      '-c*', # -Command
      '-e*', # -EncodedCommand
      '-f*', # -File
      '-noni*' # -NonInteractive
  )

  $commandLineArgs = [System.Environment]::GetCommandLineArgs()

  # True if VS Code shell integration is sourced: . "...\Microsoft VS Code\...\shellIntegration.ps1"
  # This is done in the integrated terminal
  if ($commandLineArgs -match '\.\s*\u0022.*vs\s*code.*shellIntegration\.ps1\u0022') {
      return $true
  }

  # False if the command line arguments contain any non-interactive parameters
  foreach ($arg in ($commandLineArgs | Where-Object { $_ -match '^-' })) {
      foreach ($param in $nonInteractiveParameters) {
          if ($arg -like $param) {
              return $false
          }
      }
  }

  return [System.Environment]::UserInteractive
}

if (Test-IsInteractive) {
  $AddCommandToHistory = {
      param (
          [string]
          $Command
      )

      switch ($Command) {
          (
              {
                  ($_ -match '^cd[ ]+.+') -or
                  ($_ -match '^chdir[ ]+.+') -or
                  ($_ -match '^sl[ ]+.+') -or
                  ($_ -match '^[sS]et-[lL]ocation[ ]+.+')
              }
          ) {
              return $false
          }
          (
              {
                  ($_ -contains '--help') -or
                  ($_ -contains '-h') -or
                  ($_ -contains '-?') -or
                  ($_ -match 'help$') -or
                  ($_ -match '^[gG]et-[hH]elp[ ]+.+')
              }
          ) {
              return $false
          }
          default { return $true }
      }
  }

  Import-Module -Name PSReadLine
  @{
      EditMode            = 'Windows'
      PredictionSource    = 'History'
      HistoryNoDuplicates = $true
      AddToHistoryHandler = $AddCommandToHistory
      Colors              = @{
          InlinePrediction = [System.ConsoleColor]::DarkGray
      }
  } | ForEach-Object { Set-PSReadLineOption @_ }

  . (Join-Path -Path (Split-Path -Path $PROFILE) -ChildPath 'starship.ps1')
}