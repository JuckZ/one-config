Import-Module "$($(Get-Item $(Get-Command scoop).Path).Directory.Parent.FullName)\modules\scoop-completion" -ErrorAction SilentlyContinue

# toggle self-elevate
function toggleSelfElevate {
    $selfElevate = [System.Environment]::GetEnvironmentVariable("SELF_ELEVATE", [System.EnvironmentVariableTarget]::User)

    if($null -ne $selfElevate) {
        [Environment]::SetEnvironmentVariable("SELF_ELEVATE", $null, [EnvironmentVariableTarget]::User)
    } else {
        [Environment]::SetEnvironmentVariable("SELF_ELEVATE", "enable", [EnvironmentVariableTarget]::User)
    }
}

# proxy
function proxyEnable {
    $proxy = "127.0.0.1:7890"
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyEnable -Value 1
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyServer -Value $proxy
    Write-Host "全局代理已开启: $proxy"
}
function proxyDisable {
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyEnable -Value 0
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyServer -Value ""
    Write-Host "全局代理已关闭"
}
function setProxy {
    $proxy = "127.0.0.1:7890"
    # 为当前会话设置代理
    [Environment]::SetEnvironmentVariable("HTTP_PROXY", $proxy, [EnvironmentVariableTarget]::Process)
    [Environment]::SetEnvironmentVariable("HTTPS_PROXY", $proxy, [EnvironmentVariableTarget]::Process)

    Write-Host "会话代理已开启: $proxy"
}
function unsetProxy {
    # 清除当前会话的代理设置
    [Environment]::SetEnvironmentVariable("HTTP_PROXY", $null, [EnvironmentVariableTarget]::Process)
    [Environment]::SetEnvironmentVariable("HTTPS_PROXY", $null, [EnvironmentVariableTarget]::Process)

    Write-Host "会话代理已关闭"
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