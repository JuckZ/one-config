$script_name = $MyInvocation.MyCommand.Name

# Install-Module PSScriptTools
# Get-Module PSScriptTools | Remove-Module
# Uninstall-Module PSScriptTools -AllVersions

# 依赖检查
function local:preCheck() {
  # 确保 Scoop 已安装
  if (-not (Get-Command 'scoop' -ErrorAction SilentlyContinue)) {
    Write-Host "Scoop is not installed. Please install Scoop first." -ForegroundColor Red
    exit
  }
  # 确保powershell7 已安装
  if($PSVersionTable.PSVersion.Major -ge 7) {
    Write-Host "PowerShell 7 or higher is installed."
  }
}

# 日志工具
function local:initLogger() {
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
  Set-PSRepository -InstallationPolicy Trusted -Name PSGallery

  if($null -eq $(Get-Module -Name Logging -ListAvailable)) {
    Install-Module -Name Logging -AllowClobber -Force
  }
  Import-Module Logging
  # 'DEBUG', 'INFO', 'WARNING', 'ERROR'
  Set-LoggingDefaultLevel -Level 'DEBUG'
  Add-LoggingTarget -Name Console
  Add-LoggingTarget -Name File -Configuration @{Path = "$env:TEMP\one-config_%{+%Y%m%d}.log"}
  Write-Log -Level 'INFO' -Message ">>> {0} is running" -Arguments $script_name
}

# 配置PSReadLine
function local:configPSReadLine() {
  $currentVersion = Get-Module -Name PSReadLine -ListAvailable | 
                  Sort-Object Version -Descending | 
                  Select-Object -First 1 -ExpandProperty Version

  if ($currentVersion) {
    if ($currentVersion -lt $([System.Version]"2.1.0")) {
        Install-Module -Name PSReadLine -AllowClobber -Force
        Write-Log -Level 'INFO' -Message "Update completed, please restart PowerShell to load the new version."
    }
  } else {
    Install-Module -Name PSReadLine -AllowClobber -Force
    Write-Log -Level 'INFO' -Message "Install completed, please restart PowerShell to load the new version."
  }

  $PSReadLineOptions = @{
    PredictionSource  = "History"
    HistoryNoDuplicates = $true
    HistorySearchCursorMovesToEnd = $true
    Colors = @{
        Command             = [ConsoleColor]::DarkGray
        Number              = [ConsoleColor]::DarkGreen
        Member              = [ConsoleColor]::DarkMagenta
        Operator            = [ConsoleColor]::DarkGray
        Type                = [ConsoleColor]::DarkRed
        Variable            = [ConsoleColor]::DarkYellow
        Parameter           = [ConsoleColor]::DarkGreen
        ContinuationPrompt  = [ConsoleColor]::DarkGray
        Default             = [ConsoleColor]::DarkGray
        Emphasis            = [ConsoleColor]::DarkGray
        Error               = [ConsoleColor]::DarkRed
        Selection           = [ConsoleColor]::DarkGray
        Comment             = [ConsoleColor]::DarkCyan
        Keyword             = [ConsoleColor]::DarkRed
        String              = [ConsoleColor]::DarkGray
    }
  }
  Set-PSReadLineOption @PSReadLineOptions
}

initLogger
configPSReadLine

Write-Log -Level 'INFO' -Message "<<< {0} finished" -Arguments $script_name
Wait-Logging