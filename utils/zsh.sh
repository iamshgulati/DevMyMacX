#!/bin/sh

echo "Installing zsh... \c"
if ! test $(which zsh); then
    brew install zsh &>/dev/null
else
    echo "already installed... \c"
fi
echo "Done"

echo "Activating zsh plugins..."
if test $(which zsh); then
  echo ''

  echo "Activating autojump... \c"
  brew install autojump &>/dev/null
  echo '[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && source /opt/homebrew/etc/profile.d/autojump.sh' >> ~/.zshrc
  echo "Done"

  echo "Activating zsh-syntax-highligting... \c"
  brew install zsh-syntax-highlighting &>/dev/null
  echo '[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> ~/.zshrc
  echo 'export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters' >> ~/.zshenv
  echo "Done"

  echo "Activating zsh-completions... \c"
  brew install zsh-completions &>/dev/null
  echo 'FPATH=/opt/homebrew/share/zsh/site-functions:$FPATH' >> ~/.zprofile
  rm -f ~/.zcompdump &>/dev/null; compinit &>/dev/null
  chmod -R go-w "/opt/homebrew/share" &>/dev/null
  echo "Done"

  echo "Activating zsh-autosuggestions... \c"
  brew install zsh-autosuggestions &>/dev/null
  echo '[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh' >> ~/.zshrc
  echo "Done"

  echo "Activating zsh-navigation-tools... \c"
  brew install zsh-navigation-tools &>/dev/null
  echo '[ -f /opt/homebrew/share/zsh-navigation-tools/zsh-navigation-tools.plugin.zsh ] && source /opt/homebrew/share/zsh-navigation-tools/zsh-navigation-tools.plugin.zsh' >> ~/.zshrc
  echo "Done"
fi