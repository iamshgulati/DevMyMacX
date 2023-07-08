#!/bin/sh

echo "Installing zsh theme: powerlevel10k... \c"
if test $(which zsh) && ! grep -q 'source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme' ~/.zshrc; then
  brew install romkatv/powerlevel10k/powerlevel10k &>/dev/null
  sed -io '/^ZSH_THEME/ s/^\#*/\# /' ~/.zshrc
  echo '[ -f /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme ] && source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
  # curl -Ls $DOTFILES_SRC/raw/main/macOS/zsh/p10k.zsh > ~/.p10k.zsh
  sed -io 's/^  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=.*/  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last/' ~/.p10k.zsh
  {
    echo ''
    echo '# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.'
    echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh'
  } >> ~/.zshrc
fi
echo "Done"