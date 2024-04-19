$script_name = $MyInvocation.MyCommand.Name

function initLogger() {
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

initLogger

Write-Host ">>> $script_name is running"

function local:addBucket() {
  $BucketList = @(
    "extras",
    "nerd-fonts",
    "versions"
  )

  $scoopBucketList = scoop bucket list 6> $null
  foreach ($bucket in $BucketList) {
    $addedBucket = $scoopBucketList | Where-Object { $_.Name -eq $bucket }
    if(-not $addedBucket) {
      scoop add $bucket
    }
  }
}

# 安装应用
function local:installApp() {
  class Application {
    [string]$Command = ""
    [string]$Name
    [string]$Version = "0.0.0"
    [string]$Source = "main"
    [string]$Updated = ""
    [string]$Info = ""
  }

  $AppList = @(
    [Application]@{Name = "autohotkey"; Version = "2.0.12"; Command = "autohotkey"; Source="extras"},
    [Application]@{Name = "age"; Version = "1.1.1"; Command = "age"; Source="extras"},
    [Application]@{Name = "bitwarden-cli"; Version = "2024.3.1"; Command = "bw"},
    [Application]@{Name = "scoop-completion"; Version = "0.3.0"; Command = ""; Source = "extras"},
    [Application]@{Name = "FiraCode-NF"; Source = "nerd-fonts"},
    [Application]@{Name = "JetBrainsMono-NF"; Source = "nerd-fonts"},
    [Application]@{Name = "vcredist2022"; Source = "extras"},
    [Application]@{Name = "starship"},
    [Application]@{Name = "komorebi"; Source = "extras"},
    [Application]@{Name = "komokana"; Source = "extras"},
    [Application]@{Name = "rustup"; Command = "rustup"},
    [Application]@{Name = "python310"; Version = "3.10.0"; Source = "versions"; Command = "python"},
    [Application]@{Name = "autohotkey"; Version = "2.0.0"; Source = "extras"},
    # install launcher
    [Application]@{Name = "flow-launcher"; Source = "extras"}
    # [Application]@{Name = "wox"; Source = "extras"}
  )

  $scoopApps = scoop list 6> $null

  foreach ($app in $AppList) {
    $installedApp = $scoopApps | Where-Object { $_.Name -eq $app.Name -and $_.Source -eq $app.Source }
    $str = $appInfo -split '\s+'
    if ($installedApp) {
      $installedVersion = $installedApp.Version
      if ([version]$installedVersion -lt [version]$app.Version) {
        Write-Log -Level 'INFO' -Message "$($app.Name) is installed but the version ($installedVersion) is lower than required ($($app.Version)). Updating..."
        # scoop update $($app.Name)
      }
    } elseif(-not [string]::IsNullOrEmpty($app.Command)) {
      $commandInfo = Get-Command $app.Command -ErrorAction SilentlyContinue
      if ([version]$commandInfo.Version -lt [version]$app.Version) {
        Write-Log -Level 'ERROR' -Message "$($app.Name) is installed but the version ($installedVersion) is lower than required ($($app.Version)). Updating..."
        # scoop update $($app.Name)
      }
    } else {
      Write-Log -Level 'WARNING' -Message "$($app.Name) is not installed. Installing..."
      # scoop install $($app.Name)
    }
  }
}

function local:extraInstall() {
  cargo install kanata
  cd ~/Projects/yasb && pip install -r requirements.txt && cd -
}

addBucket
installApp
# extraInstall

Write-Host "<<< $script_name finished"