#!/bin/sh

# Input variables
EDITOR=$1

# Script variables
DEFAULT_DOTFILES_REPO='https://github.com/iamshgulati/dotfiles'

setup_vscode () {
    echo "Installing up VSCode..."
    if ! test $(which code); then
        brew install --cask visual-studio-code &>/dev/null
    fi

    echo "Installing VSCode extensions... \c"
    sh -c "$(curl -fsSL $DEFAULT_DOTFILES_REPO/raw/main/macOS/vscode/install-extensions.sh)" "" "code" &>/dev/null
    echo "Done"

    # Mackup will restore user's settings.json
    # echo "Installing VSCode user settings... \c"
    # curl -Ls $DEFAULT_DOTFILES_REPO/raw/main/macOS/vscode/settings.json > ~/Library/Application\ Support/Code/User/settings.json
    # echo "Done"
}

while [[ "$#" -gt 0 ]]; do
    case $EDITOR in
        -vscode|--visual-studio-code) setup_vscode; shift ;;
        *) echo "$0: Unknown parameter passed: $EDITOR"; exit 1 ;;
    esac
    shift
done