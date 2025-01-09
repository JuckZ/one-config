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

function local:Stop-Whkd() {
  komorebic stop --whkd
}

function local:Stop-Komorebi() {
  komorebic stop
  Get-Process | Where-Object {$_.ProcessName -like "*komorebi*"} | Stop-Process
  Get-Process | Where-Object {$_.ProcessName -like "*autohotkey*"} | Stop-Process
}

function local:Start-Yasb() {
  # 设置yasb Python脚本的路径
  $yasbScriptPath = "$env:PROJECT_HOME\yasb\src\main.py"
  Start-Process "pythonw" -ArgumentList "$yasbScriptPath" -NoNewWindow
}

function local:Stop-Yasb() {
  Get-CimInstance Win32_Process | Select-Object ProcessId, Name, CommandLine | Where-Object {$_.Name -like "*python*" -and $_.CommandLine -like "*$env:PROJECT_HOME\yasb\src\main.py*"} | Stop-Process -Id {$_.ProcessId}
}

function local:Start-Kanata() {
  # kanata -d -p 10110 -c "$env:USERPROFILE\.config\kanata\kanata.kbd"
  # C:\Windows\System32\conhost.exe --headless C:\kanata\kanata.exe --cfg C:\kanata\kanata.kbd
  Start-Process "pwsh" -ArgumentList "-NoLogo -Command & { kanata -d -p 10110 -c `"$env:USERPROFILE\.config\kanata\kanata.kbd`" } > $env:TEMP\kanata.log" -NoNewWindow
}

function local:Stop-Kanata() {
  # lctl+spc+esc now terminates kanata
  Get-Process | Where-Object {$_.ProcessName -like "*kanata*"} | Stop-Process
}

function local:Start-Komokana() {
  # komokana -t -d qwerty -p 10110 -c "$env:USERPROFILE\.config\komokana\komokana.yaml"
  Start-Process "komokana" -ArgumentList "-t -d qwerty -p 10110 -c `"$env:USERPROFILE\.config\komokana\komokana.yaml`"" -NoNewWindow
}

function local:Stop-Komokana() {
  Get-Process | Where-Object {$_.ProcessName -like "*komokana*"} | Stop-Process
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

function Start-Komponent {
  param([string]$component)
  "Starting $component"
  switch ($component) {
    'whkd' {
      Start-Whkd
    }
    'yasb' {
      Start-Yasb
    }
    Default {
      "$component does not support!"
    }
  }
}

function Stop-Komponent {
  param([string]$component)
  "Stopping $component"
  switch ($component) {
    'yasb' {
      Stop-Yasb
    }
    Default {
      "$component does not support!"
    }
  }
}

# 创建模块并导入到全局作用域(中文注释很有可能导致代码块报错，因此加一个英文分号结尾);
$KomoModule = New-Module -ScriptBlock {
  function Komo() {
    param(
      [Parameter(Mandatory=$false)]
      [ValidateSet('start', 'stop', 'help')]
      [string]$Operation = "help",

      [Parameter(Mandatory=$false)]
      [string[]]$Options
    )
    
    switch ($Operation) {
      'start' {
        foreach ($opt in $Options) {
          if ($opt -match '--(.*)') {
            Start-Komponent -component $Matches[1]
          }
        }
        if(-not $Options) {
          Start-Kanata
          Start-Komorebi
          Start-Yasb
          Start-Komokana
          "Komo started."
        }
      }
      'stop' { 
        foreach ($opt in $Options) {
          if ($opt -match '--(.*)') {
            Stop-Komponent -component $Matches[1]
          }
        }
        if (-not $Options) {
          Stop-Komokana
          Stop-Yasb
          Stop-Komorebi
          Stop-Kanata
          "Komo stopped."
        }
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