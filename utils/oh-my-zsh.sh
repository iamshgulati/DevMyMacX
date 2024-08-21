#!/bin/sh

echo "Installing Oh My Zsh... \c"
if test $(which zsh) && [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended &>/dev/null
  echo "Done"

  echo "Changing oh-my-zsh theme... \c"
  sed -io 's/^ZSH_THEME=.*/ZSH_THEME="agnoster"/' ~/.zshrc
  echo "Done"
  
  echo "Update cli to show only current directory"
  {
      echo ''
      echo '# Show only current directory'
      echo 'prompt_dir() {'
      echo '  prompt_segment blue $CURRENT_FG '\''%1c'\'''
      echo '}'
  } >> ~/.zshrc
  echo "Done"

  echo "Activating oh-my-zsh plugins... \c"
  sed -io 's/^plugins=.*/plugins=(git brew common-aliases copypath copyfile node macos docker git-extras git-prompt)/' ~/.zshrc
  echo "Done"
fi