# komorebic.exe quick-start
# komorebic.exe ahk-library
# komorebic.exe enable-autostart --ahk
# komorebic.exe disable-autostart

$script:tempModule = New-Module -AsCustomObject -ScriptBlock {
  function SetEnv {
    $Env:PROJECT_HOME = "$env:USERPROFILE\Projects"
    $Env:KOMOREBI_CONFIG_HOME = "$env:USERPROFILE\.config\komorebi"
    $Env:WHKD_CONFIG_HOME = "$env:USERPROFILE\.config\whkd"
  }

  Export-ModuleMember -Function SetEnv
}

$script:tempModule.SetEnv()

function local:Start-Komorebi() {
  # Invoke-Expression -Command "komorebic start --whkd"
  # komorebic start --ffm -t=12345 --whkd
  # komorebic watch-configuration enable
  komorebic start --ahk
}

function local:Stop-Komorebi() {
  komorebic stop
}

function local:Start-Yasb() {
  # 设置yasb Python脚本的路径
  $yasbScriptPath = "$env:PROJECT_HOME\yasb\src\main.py" # 根据实际路径调整
  $process = Start-Process "python" -ArgumentList "$yasbScriptPath" -PassThru -NoNewWindow
  $yasbPid = $process.Id
  Write-Log -Level 'INFO' -Message "Python script is running in the background. Job ID: {0}" -Arguments $yasbPid
  # Set-Content "$env:TEMP\yasb.pid" "$yasbPid"
  [Environment]::SetEnvironmentVariable("YASB_PID", "$yasbPid", [EnvironmentVariableTarget]::User)
}

function local:Stop-Yasb() {
  $yasbPid = [System.Environment]::GetEnvironmentVariable("YASB_PID", [System.EnvironmentVariableTarget]::User)
  # $yasbPidFromFile = Get-Content "$env:TEMP\yasb.pid" -Raw
  if ($null -ne $yasbPid) {
    try {
      Stop-Process -Id "$yasbPid"
    } catch {
        Write-Log -Level 'WARNING' -Message "Process with ID {0} does not exist." -Arguments $yasbPid
    }
    [Environment]::SetEnvironmentVariable("YASB_PID", $null, [EnvironmentVariableTarget]::User)
  } else {
    Write-Log -Level 'WARNING' -Message "Environment variable 'YASB_PID' does not exist."
  }
}

function local:Start-Kanata() {
  # kanata -d -p 10110 -c "$env:USERPROFILE\.config\kanata\kanata.kbd"
  # C:\Windows\System32\conhost.exe --headless C:\kanata\kanata.exe --cfg C:\kanata\kanata.kbd
  Start-Process "pwsh" -ArgumentList "-NoLogo -Command & { kanata -d -p 10110 -c `"$env:USERPROFILE\.config\kanata\kanata.kbd`" } > $env:TEMP\kanata.log" -NoNewWindow
}

function local:Stop-Kanata() {
  # lctl+spc+esc now terminates kanata
  Get-Process "kanata" | Stop-Process
}

function local:Start-Komokana() {
  # komokana -t -d qwerty -p 10110 -c "$env:USERPROFILE\.config\komokana\komokana.yaml"
  Start-Process "komokana" -ArgumentList "-t -d qwerty -p 10110 -c `"$env:USERPROFILE\.config\komokana\komokana.yaml`"" -NoNewWindow
}

function local:Stop-Komokana() {
  Get-Process "komokana" | Stop-Process
}

class Command {
  [string]$Command
  [string]$Flag
  [string]$Description
}

$CommandList = @(
  [Command]@{Command = "komo start"; Flag = ""; Description = "Starts all Komo services."},
  [Command]@{Command = "komo stop"; Flag = ""; Description = "Stops all Komo services."},
  [Command]@{Command = "komo help"; Flag = ""; Description = "Displays this help information."},
  [Command]@{Command = "komo enable"; Flag = "--now"; Description = "Start now and enable autostart."}
  [Command]@{Command = "komo disable"; Flag = "--now"; Description = "Stop now and disable autostart."}
)

function local:Show-Tips() {
  Write-Host "Usage of the Komo command" -ForegroundColor Green

  Write-Host "`nUsage:`n  komo [command]"

  Write-Host "`nAvailable Commands: "

  foreach ($command in $CommandList) {
    Write-Host ("  {0,-20} {1, -15} {2}" -f $command.Command, $command.Flag, $command.Description)
  }

  Write-Host "`nFlags:"
  Write-Host "    -c, --config path        Set config file(not work now)"

  Write-Host "`nUse `"komo [command] --help`" for more information about a command.(not work now)"
}

# 创建模块并导入到全局作用域
$KomoModule = New-Module -ScriptBlock {
  function Komo() {
    param(
      [Parameter(Mandatory=$false)]
      [ValidateSet('start', 'stop', 'help')]
      [string]$Operation = "help"
    )
    
    switch ($Operation) {
      'start' {
        Start-Kanata
        Start-Komorebi
        Start-Yasb
        Start-Komokana
        "Komo started."
      }
      'stop' { 
        Stop-Komokana
        Stop-Yasb
        Stop-Komorebi
        Stop-Kanata
        "Komo stopped."
      }
      'help' {
        Show-Tips
      }
      Default {
        Show-Tips
      }
    }
  }

  Export-ModuleMember -Function 'Komo'
}

# 将模块导入全局作用域
Import-Module -ModuleInfo $KomoModule