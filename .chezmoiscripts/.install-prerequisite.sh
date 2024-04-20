#!/bin/zsh

source ~/.local/share/chezmoi/.chezmoiscripts/.log.sh 

script_name=$(basename "$0")
log_message "INFO" ">>> $script_name is running"

case "$(uname -s)" in
Darwin)
    type bw >/dev/null 2>&1 || brew install bitwarden-cli
    type age >/dev/null 2>&1 || brew install age
    # Install Xcode cli tools
    echo "Installing commandline tools..."
    xcode-select --install
    ;;
Linux)
    type bw >/dev/null 2>&1 || pacman -S bitwarden-cli
    type bw >/dev/null 2>&1 || pacman -S age
    # apt install bitwarden-cli # perhaps not exist
    # apt install age
    # yum install ...
    ;;
*)
    echo "unsupported OS"
    exit 1
    ;;
esac

log_message "INFO" "<<< $script_name finished"