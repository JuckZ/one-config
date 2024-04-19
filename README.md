# One Config

Config everything once.

## TODO

- [ ] hyprland的快捷键
  - [ ] 鼠标和键盘协同resize Command + RButton
  - [ ] 任务栏、菜单栏切换
  - [ ] 配置热重载
- [ ] proxy从chezmoidata中获取初始值，并赋值给全局，用于各个软件

## Features

1. [Rime config](https://github.com/hugh7007/xmjd6-rere)
2. Cross Platform(Linux, macOS, Windows)
3. toggle self-elevate
4. useful alias
5. komo module

## Usage

### Installation

1. Windows

```powershell
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
winget install --id Microsoft.Powershell --source winget
iwr -useb get.scoop.sh | iex
# winget list --name PowerShell --upgrade-available
scoop install chezmoi
```

2. Manjaro/Archlinux

```sh
sudo pacman -S chezmoi
```

3. MacOS

```sh
brew install chezmoi
```

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