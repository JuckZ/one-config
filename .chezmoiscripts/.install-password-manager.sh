#!/bin/sh

script_name=$(basename "$0")
echo ">>> $script_name is running"

# exit immediately if bw is already in $PATH
# type bw >/dev/null 2>&1 && exit

case "$(uname -s)" in
Darwin)
    brew install bitwarden-cli
    brew install age
    ;;
Linux)
    pacman -S bitwarden-cli
    pacman -S age
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