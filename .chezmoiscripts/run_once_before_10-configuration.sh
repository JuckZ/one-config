#!/bin/zsh

script_name=$(basename "$0")
echo ">>> $script_name is running"

# 禁用自动休眠:这是休眠的一种形式
# 禁用powernap:用于定期唤醒机器以进行网络和更新(但不包括显示)
# 禁用待机:用于睡眠和进入休眠之间的一段时间
# 禁用iPhone/手表唤醒功能:特别是当你的iPhone或苹果手表靠近时，机器将唤醒
# 关闭TCP保持激活机制，防止每2小时唤醒一次
sudo pmset autopoweroff 0
sudo pmset powernap 0
sudo pmset standby 0
sudo pmset proximitywake 0
sudo pmset tcpkeepalive 0

# Install Xcode cli tools
echo "Installing commandline tools..."
xcode-select --install

# Homebrew
## Install
echo "Installing Brew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew analytics off

brew install chezmoi

## Taps
echo "Tapping Brew..."
brew tap homebrew/cask-fonts
brew tap FelixKratz/formulae
brew tap koekeishiya/formulae

### Essentials
brew install wget
brew install jq
# brew install gsl
# brew install llvm
# brew install boost
# brew install libomp
# brew install armadillo
# brew install ripgrep
# brew install bear
# brew install mas
# brew install gh
# brew install ifstat

## Formulae
echo "Installing Brew Formulae..."
### Desktop
brew install skhd
brew install sketchybar
brew install svim
brew install borders
brew install yabai
# SbarLua
(git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && cd /tmp/SbarLua/ && make install && rm -rf /tmp/SbarLua/)

### Development
brew install cmake
brew install ccache
brew install vulkan-tools
brew install lua
brew install micromamba
brew install lazygit

### Science
# brew install mactex
# brew install hdf5
# brew install gnuplot
# brew install texlab

### Terminal
brew install zsh-autosuggestions
# brew install zsh-fast-syntax-highlighting
brew install zsh-syntax-highlighting
brew install starship
brew install --cask alacritty
brew install --cask kitty

### Network
brew install v2raya
brew install wireguard-go
brew install wget

### Misc
brew install nnn
brew install btop
brew install jq
brew install ripgrep
brew install mas
brew install switchaudio-osx
brew install nowplaying-cli
# brew install --cask orion


## Casks
echo "Installing Brew Casks..."
### Essential
brew install --cask visual-studio-code
brew install --cask kitty
brew install --cask google-chrome

### Office
brew install --cask wpsoffice
# brew install --cask libreoffice
# brew install --cask dingtalk
brew install --cask feishu
brew install --cask inkscape
brew install --cask meetingbar

### Fonts
brew install --cask sf-symbols
brew install --cask font-hack-nerd-font
brew install --cask font-sf-mono
brew install --cask font-sf-pro
brew install --cask font-jetbrains-mono
brew install --cask font-fira-code
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.5/sketchybar-app-font.ttf -o $HOME/Library/Fonts/sketchybar-app-font.ttf

### Nice to have
brew install lulu
brew install dooit

# Mac App Store Apps
echo "Installing Mac App Store Apps..."
mas install 497799835 #Xcode
# mas install 1451685025 #Wireguard
# mas install 1480933944 #Vimari

# macOS Settings
echo "Changing macOS defaults..."
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 1000
defaults write com.apple.dock no-bouncing -bool TRUE
# killall Dock
defaults write NSGlobalDomain _HIHideMenuBar -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.Finder AppleShowAllFiles -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder ShowStatusBar -bool false

# defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1
# defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# defaults write com.apple.spaces spans-displays -bool false
# defaults write com.apple.dock "mru-spaces" -bool "false"
# defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
# defaults write com.apple.LaunchServices LSQuarantine -bool false
# defaults write NSGlobalDomain KeyRepeat -int 1
# defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
# defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# defaults write NSGlobalDomain AppleHighlightColor -string "0.65098 0.85490 0.58431"
# defaults write NSGlobalDomain AppleAccentColor -int 1
# defaults write com.apple.screencapture location -string "$HOME/Desktop"
# defaults write com.apple.screencapture disable-shadow -bool true
# defaults write com.apple.screencapture type -string "png"
# defaults write com.apple.finder DisableAllAnimations -bool true
# defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
# defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool YES
# defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
# defaults write com.apple.Safari IncludeDevelopMenu -bool true
# defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
# defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
# defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
# defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false
# defaults write -g NSWindowShouldDragOnGesture YES

# Copying and checking out configuration files
echo "Cloning Config"
# 判断是否已经存在chezmoi
chezmoi init --ssh --depth 1 JuckZ/one-config 
chezmoi apply $HOME/.config/sketchybar

# Installing Fonts
git clone git@github.com:shaunsingh/SFMono-Nerd-Font-Ligaturized.git /tmp/SFMono_Nerd_Font
mv /tmp/SFMono_Nerd_Font/* $HOME/Library/Fonts
rm -rf /tmp/SFMono_Nerd_Font/

# Zsh
source $HOME/.zshrc
# cfg config --local status.showUntrackedFiles no

## Fix for MX Master 3S
sudo defaults write /Library/Preferences/com.apple.airport.bt.plist bluetoothCoexMgmt Hybrid

# Git
git config --global user.name Juck
git config --global user.email juckz@foxmail.com
git config --global pull.rebase true
# git config --global credential.help true

# Start Services
echo "Starting Services (grant permissions)..."
skhd --start-service
yabai --start-service
brew services start sketchybar
brew services start borders
brew services start svim

csrutil status
echo "(optional) Disable SIP for advanced yabai features."
echo "(optional) Add sudoer manually:\n '$(whoami) ALL = (root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | awk "{print \$1;}") $(which yabai) --load-sa' to '/private/etc/sudoers.d/yabai'"

echo "Installation complete...\n"

echo "<<< $script_name finished"