# One Config

Config everything once.

## TODO

- [ ] 如何组织某些平台运行某些脚本

## Features

1. [Rime config](https://github.com/hugh7007/xmjd6-rere)
2. Cross Platform(Linux, macOS, Windows)

## Usage

### Installation

1. Windows

```powershell
scoop bucket add nerd-fonts
scoop install nerd-fonts/FiraCode-NF
scoop install nerd-fonts/JetBrainsMono-NF
scoop install extras/vcredist2022
scoop install starship
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

### Install Application

1. [komorebi](./docs/komorebi.md)
2. [yabai](./docs/yabai.md)

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

https://www.chezmoi.io/user-guide/frequently-asked-questions/encryption/#how-do-i-configure-chezmoi-to-encrypt-files-but-only-request-a-passphrase-the-first-time-chezmoi-init-is-run


Generate an age private key encrypted with a passphrase in the file key.txt.age with the command:
`age-keygen | age --armor --passphrase > key.txt.age`

`chezmoi init --apply` 可以生成key.txt

`chezmoi add --encrypt ~/.ssh/id_rsa` 添加加密文件

`chezmoi managed --include encrypted --path-style absolute` 查看所有的加密文件