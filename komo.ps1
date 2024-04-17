param(
  [string]$operation,
  [string]$debug
)

function Start-Komorebi() {
  # Invoke-Expression -Command "komorebic start --whkd"
  # komorebic start --ffm -t=12345 --whkd
  komorebic start --ahk
}

function Stop-Komorebi() {
  komorebic stop
}

function Start-Yasb() {
  # 设置yasb Python脚本的路径
  $yasbScriptPath = "$env:PROJECT_HOME\yasb\src\main.py" # 根据实际路径调整
  $process = Start-Process "python" -ArgumentList "$yasbScriptPath" -PassThru -NoNewWindow
  $yasbPid = $process.Id
  Write-Host "Python script is running in the background. Job ID: $yasbPid"
  # Set-Content "$env:TEMP\yasb.pid" "$yasbPid"
  [Environment]::SetEnvironmentVariable("YASB_PID", "$yasbPid", [EnvironmentVariableTarget]::User)
}

function Stop-Yasb() {
  $yasbPid = [System.Environment]::GetEnvironmentVariable("YASB_PID", [System.EnvironmentVariableTarget]::User)
  # $yasbPidFromFile = Get-Content "$env:TEMP\yasb.pid" -Raw
  if ($null -ne $yasbPid) {
    try {
      Stop-Process -Id "$yasbPid"
    } catch {
        Write-Host "Process with ID $yasbPid does not exist."
    }
    [Environment]::SetEnvironmentVariable("YASB_PID", $null, [EnvironmentVariableTarget]::User)
  } else {
    Write-Host "Environment variable 'YASB_PID' does not exist."
  }
}

function Start-Kanata() {
  # kanata -d -p 10110 -c "$env:USERPROFILE\.config\kanata\kanata.kbd"
  # C:\Windows\System32\conhost.exe --headless C:\kanata\kanata.exe --cfg C:\kanata\kanata.kbd
  Start-Process "powershell.exe" -ArgumentList "-NoLogo -Command & { kanata -d -p 10110 -c `"$env:USERPROFILE\.config\kanata\kanata.kbd`" } > $env:TEMP\kanata.log" -NoNewWindow
}

function Stop-Kanata() {
  Get-Process "kanata" | Stop-Process
}

function Start-Komokana() {
  # komokana -t -d qwerty -p 10110 -c "$env:USERPROFILE\.config\komokana\komokana.yaml"
  Start-Process "komokana" -ArgumentList "-t -d qwerty -p 10110 -c `"$env:USERPROFILE\.config\komokana\komokana.yaml`"" -NoNewWindow
}

function Stop-Komokana() {
  Get-Process "komokana" | Stop-Process
}

function Main() {
  if ($debug -like "*-d*") {
    # TODO 开启debug
  }

  if ($operation -like "stop") {

    Write-Host "===== Stop-Komokana ======"
    Stop-Komokana

    Write-Host "===== Stop-Yasb ======"
    Stop-Yasb

    Write-Host "===== Stop-Komorebi ======"
    Stop-Komorebi

    Write-Host "===== Stop-Kanata ======"
    Stop-Kanata # lctl+spc+esc now terminates kanata

    Write-Host "===== Finished ======"

  }
  else {
    Write-Host "===== Start-Kanata ======"
    Start-Kanata # lctl+spc+esc now terminates kanata

    Write-Host "===== Start-Komorebi ======"
    Start-Komorebi

    Write-Host "===== Start-Yasb ======"
    Start-Yasb

    Write-Host "===== Start-Komokana ======"
    Start-Komokana

    Write-Host "===== Finished ======"
  }
  exit
}

Main