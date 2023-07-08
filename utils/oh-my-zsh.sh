#!/bin/sh

echo "Installing Oh My Zsh... \c"
if test $(which zsh) && [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended &>/dev/null
  echo "Done"

  echo "Activating oh-my-zsh plugins... \c"
  sed -io 's/^plugins=.*/plugins=(git brew common-aliases copypath copyfile encode64 node macos xcode pod docker git-extras git-prompt)/' ~/.zshrc
  echo "Done"
fi