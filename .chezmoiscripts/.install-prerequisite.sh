#!/bin/sh

script_name=$(basename "$0")
echo ">>> $script_name is running"

case "$(uname -s)" in
Darwin)
    type bw >/dev/null 2>&1 || brew install bitwarden-cli
    type age >/dev/null 2>&1 || brew install age
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

echo "<<< $script_name finished"