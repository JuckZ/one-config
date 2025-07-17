# One Config

Config everything once.

## TODO

- [ ] github 代码审查，避免信息泄露
- [ ] menubar
  - [ ] 自己开发，使用electron学习 或者 Flutter
  - [ ] yasb配置，wifi，以及卡顿问题和安装的便捷性问题
- [ ] hyprland的快捷键
  - [ ] 鼠标和键盘协同resize Command + RButton
  - [ ] 任务栏、菜单栏切换
  - [ ] 配置热重载
- [ ] proxy从chezmoidata中获取初始值，并赋值给全局，用于各个软件
- [ ] 软件区分必要和额外
- [ ] zsh
  - [ ] oh-my-zsh
  - [ ] starship
- [ ] vim global
  - [ ] svim
- [ ] lazygit
- [ ] ranger nnn fzf
- [ ] 翻译工具
- [ ] zoxide
- [ ] 同步到 https://github.com/manjaro-hyprland/desktop-settings/blob/hyprland/community/hyprland/etc/skel/.config
- [ ] winsw 测试
- [ ] win-get notfound，增加path `%USERPROFILE%\AppData\Local\Microsoft\WindowsApps`

## Features

1. Input method - [one-input](https://github.com/JuckZ/one-input)
2. Cross Platform(Linux, macOS, Windows)
3. toggle self-elevate
4. useful alias
5. komo module
   1. Alt + RButton: resize window
   2. Alt + LButton: move window
   3. Alt + Shift + R: reload
6. [LazyVim](https://www.lazyvim.org/) for [neovim](https://neovim.io/)
7. [Lazygit](https://github.com/jesseduffield/lazygit)

## Usage

### Installation

1. Windows

> 目前需手动安装字体[OneFont](https://github.com/JuckZ/one-font)，以支持yasb

```powershell
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
winget install --id Microsoft.Powershell --source winget
iwr -useb get.scoop.sh | iex
# winget list --name PowerShell --upgrade-available
scoop install chezmoi
# Download and install fnm:
winget install Schniz.fnm
# Add the following to the end of your profile file:(https://github.com/Schniz/fnm#shell-setup)
fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression
# fnm ships its completions with the binary:
# fnm completions --shell powershell
# Download and install Node.js:
fnm install 22
# Verify the Node.js version:
node -v # Should print "v22.14.0".
# Download and install pnpm:
corepack enable pnpm
# corepack install --global yarn@x.y.z 
# Verify pnpm version:
pnpm -v
```

其他可选软件
scoop install maven@3.6.1
scoop install maven@3.6.3
scoop install sing-box
scoop install extras/v2rayn
scoop install extras/ventoy
scoop install main/scrcpy
scoop install main/sndcpy
scoop install extras/qtscrcpy
scoop install adb
scoop install just
scoop install extras/vlc
scoop install extras/kando
scoop install main/poetry

scoop install extras/motrix
scoop install main/kubectl


Spacedesk

AirServer
Reflector
QuickTime Player
wormhole
AirDroid Cast

1. 截图软件

- scoop install extras/screentogif
- scoop install extras/sharex

2. Manjaro/Archlinux

```sh
sudo pacman -S chezmoi
```

3. MacOS

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew analytics off
brew install chezmoi
#(optional) Disable SIP for advanced yabai features.
csrutil disable
```

#### Note

> macOS中，很多应用的权限需要手动在图形化界面中点击授权，因此首次安装后很有可能需要手动操作才能看到期望的效果

### Pre

1. change the .chezmoidata.yaml
2. change the .chezmoi.toml.tmpl
   1. `[age]` section [optional]

### Apply configuration

```bash
chezmoi init JuckZ/one-config
# Example: apply my config via SSH, --apply 会覆盖原有的配置文件
chezmoi init --ssh --depth 1 --apply JuckZ/one-config
```

### KeyMapping

keyclu, KeyCue or CheatSheet for macOS
Keyboard Manager in PowerToys, CheatKeys for Windows
[KeyCombiner](https://keycombiner.com/) for Linux?

## Reference

### chezmoi CLI reference

```sh
# 应用（会覆盖原有的配置文件）
chezmoi apply
# 对比
chezmoi diff
# 保存到git
chezmoi add 
# 编辑
chezmoi edit
```

Generate an age private key encrypted with a passphrase in the file key.txt.age with the command:
`age-keygen | age --armor --passphrase > key.txt.age`

`chezmoi init --apply` 可以生成key.txt

`chezmoi add --encrypt ~/.ssh/id_rsa` 添加加密文件

`chezmoi managed --include encrypted --path-style absolute` 查看所有的加密文件

## Thanks

- [wincent](https://github.com/wincent/wincent)