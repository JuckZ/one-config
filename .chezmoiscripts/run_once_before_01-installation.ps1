$script_name = $MyInvocation.MyCommand.Name

function initLogger() {
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

function local:addSource() {
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
    [Application]@{Name = "everything"; Version = "1.4.1.1024"; Command = "everything"; Source = "extras"},
    [Application]@{Name = "mpv"; Version = "0.38.0"; Command = "mpv"; Source = "extras"},
    [Application]@{Name = "zoxide"; Version = "0.9.4"},
    [Application]@{Name = "fzf"; Version = "0.50.0"},
    [Application]@{Name = "lazygit"; Version = "0.41.0"; Source = "extras"},
    [Application]@{Name = "FiraCode-NF"; Source = "nerd-fonts"},
    [Application]@{Name = "JetBrainsMono-NF"; Source = "nerd-fonts"},
    [Application]@{Name = "vcredist2022"; Source = "extras"},
    [Application]@{Name = "alacritty"; Version = "0.13.2"; Source = "extras"},
    # [warp](https://app.warp.dev/get_warp)
    [Application]@{Name = "starship"},
    [Application]@{Name = "komorebi"; Source = "extras"},
    [Application]@{Name = "komokana"; Source = "extras"},
    [Application]@{Name = "rustup"; Command = "rustup"},
    [Application]@{Name = "python310"; Version = "3.10.0"; Source = "versions"; Command = "python"},
    [Application]@{Name = "autohotkey"; Version = "2.0.0"; Source = "extras"},
    # install launcher, flow-launcher, wox or Rubick?
    [Application]@{Name = "flow-launcher"; Version = "1.17.2"; Source = "extras"}
    # [Application]@{Name = "wox"; Source = "extras"}
    # [rubick](https://github.com/rubickCenter/rubick)
  )

  $scoopApps = scoop list 6> $null

  foreach ($app in $AppList) {
    $installedApp = $scoopApps | Where-Object { $_.Name -eq $app.Name -and $_.Source -eq $app.Source }
    $str = $appInfo -split '\s+'
    $installedVersion = $null
    $commandInfo = $null
    if ($installedApp) {
      $installedVersion = $installedApp.Version
      if ([version]$installedVersion -lt [version]$app.Version) {
        Write-Log -Level 'INFO' -Message "$($app.Name) is installed but the version ($installedVersion) is lower than required ($($app.Version)). Updating..."
        scoop update "$($app.Source)/$($app.Name)"
      }
    } elseif(-not [string]::IsNullOrEmpty($app.Command)) {
      $commandInfo = Get-Command $app.Command -ErrorAction SilentlyContinue
      if(-not $commandInfo) {
        Write-Log -Level 'WARNING' -Message "$($app.Name) is not installed. Installing..."
        scoop install "$($app.Source)/$($app.Name)"
      } elseif ([version]$commandInfo.Version -lt [version]$app.Version) {
        Write-Log -Level 'ERROR' -Message "$($app.Name) is installed but the version ($installedVersion) is lower than required ($($app.Version)). Updating..."
        scoop update "$($app.Source)/$($app.Name)"
      }
    } else {
      Write-Log -Level 'WARNING' -Message "$($app.Name) is not installed. Installing..."
      scoop install "$($app.Source)/$($app.Name)"
    }
  }
}

function local:extraInstall() {
  cargo install kanata
  cd ~/Projects/yasb && pip install -r requirements.txt && cd -
}

function local:sync() {
  chezmoi add -T ~/.config/scoop/config.json
}

addSource
installApp
# extraInstall
sync

Write-Host "<<< $script_name finished"