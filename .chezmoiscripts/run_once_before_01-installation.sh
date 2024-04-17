#!/bin/zsh

script_name=$(basename "$0")
echo ">>> $script_name is running"

{{ if eq .chezmoi.os "linux" -}}
sudo apt install ripgrep
{{ else if eq .chezmoi.os "darwin" -}}
brew install ripgrep
{{ end -}}

brew bundle --no-lock --file=/dev/stdin <<EOF
# Download sing-box (macOS standalone version) or from [App Store](https://apps.apple.com/us/app/sing-box/id6451272673)
brew "sfm" 
cask "todesk"
cask "raycast"
cask "snipaste"
cask "monitorcontrol"
cask "hammerspoon"
cask "unlox"
cask "downie"
cask "paragon-ntfs"
EOF

### Terminal
brew install neovim
brew install helix
brew install zoxide
### Custom HEAD only forks
brew install fnnn --head # nnn fork (changed colors, keymappings)

### Reversing
brew install --cask machoview
brew install --cask hex-fiend
brew install --cask cutter
brew install --cask sloth

brew install --cask alt-tab
brew install --cask balenaetcher
brew install dash
brew install docker
brew install --cask dockmate
brew install --cask firefox
brew install --cask geekbench
brew install --cask intellij-idea
brew install --cask iterm2
brew install --cask karabiner-elements
brew install --cask keycastr # 替代品 Keyviz
brew install --cask little-snitch
brew install --cask obs
brew install --cask qq
brew install --cask qqmusic
brew install --cask youku
brew install --cask vlc

brew install --cask swiftbar
brew install --cask stats

brew install --cask parsec
brew install --cask pock

#hackintosh
brew install --cask opencore-configurator
brew install --cask opencore-patcher


# Anaconda
/opt/homebrew/anaconda3/bin/conda init zsh
# Python Packages (mainly for data science)
echo "Installing Python Packages..."
curl https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-arm64.sh | sh
source $HOME/.zshrc
conda install -c apple tensorflow-deps
conda install -c conda-forge pybind11
conda install matplotlib
conda install jupyterlab
conda install seaborn
conda install opencv
conda install joblib
conda install pytables
pip install tensorflow-macos
pip install tensorflow-metal
pip install debugpy
pip install sklearn

# Installing helix language server
git clone https://github.com/estin/simple-completion-language-server.git /tmp/simple-completion-language-server
(cd /tmp/simple-completion-language-server && cargo install --path .)
rm -rf /tmp/simple-completion-language-server

echo "<<< $script_name finished"