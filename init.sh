#!/bin/sh

source utils/functions.sh

# Input variables
SETUP_MODE=$1
SETUP_PACKAGE=$2

# Homebrew variables
DEFAULT_BREWFILES_CHECHOUT_LOCATION=$(dirname "$0")/.brewfiles
DEFAULT_BREWFILE_APP_STORE='Brewfile-1-App-Store-Bundle'
DEFAULT_BREWFILE_ESSENTIALS='Brewfile-2-Essential-Bundle'
DEFAULT_BREWFILE_DEVELOPER='Brewfile-3-Developer-Bundle'
DEFAULT_BREWFILE_MSOFFICE='Brewfile-4-MS-Office-Bundle'

# Script variables
DEFAULT_PROMPT_TIMEOUT=0
DEFAULT_EDIT_BREWFILES='n'
DEFAULT_INSTALL_BUNDLE_ESSENTIALS='y'
DEFAULT_INSTALL_BUNDLE_DEVELOPMENT='n'
DEFAULT_INSTALL_BUNDLE_MSOFFICE='n'
DEFAULT_DELETE_ALL_DOCK_ICONS='n'

# # Check if XCode Command line tools are installed
# echo
# check_cli_tools_installed

# Ask for the administrator password upfront.
echo "Requesting admin access... \c"
sudo -v
echo "${GREEN}Running as admin${NC}"

# Keep sudo until script is finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

interactive_setup() {
  PROMPT_TIMEOUT=$1
  [ -z "${PROMPT_TIMEOUT}" ] && PROMPT_TIMEOUT=$DEFAULT_PROMPT_TIMEOUT;

  echo
  echo "Computer name [default: ${BLUE}$DEFAULT_COMPUTER_NAME${NC}]"; read -t $PROMPT_TIMEOUT -n 50 -sp "--> " COMPUTER_NAME ; [ -z "${COMPUTER_NAME}" ] && COMPUTER_NAME=$DEFAULT_COMPUTER_NAME; echo ${GREEN}$COMPUTER_NAME${NC}; echo
  echo "Hostname [default: ${BLUE}$DEFAULT_HOSTNAME${NC}]"; read -t $PROMPT_TIMEOUT -n 50 -sp "--> " HOSTNAME ; [ -z "${HOSTNAME}" ] && HOSTNAME=$DEFAULT_HOSTNAME; echo ${GREEN}$HOSTNAME${NC}; echo
  echo "Local Hostname [default: ${BLUE}$DEFAULT_LOCAL_HOSTNAME${NC}]"; read -t $PROMPT_TIMEOUT -n 50 -sp "--> " LOCAL_HOSTNAME ; [ -z "${LOCAL_HOSTNAME}" ] && LOCAL_HOSTNAME=$DEFAULT_LOCAL_HOSTNAME; echo ${GREEN}$LOCAL_HOSTNAME${NC}; echo
  echo "Git user name [default: ${BLUE}$DEFAULT_GIT_USER_NAME${NC}]"; read -t $PROMPT_TIMEOUT -n 50 -sp "--> " GIT_USER_NAME ; [ -z "${GIT_USER_NAME}" ] && GIT_USER_NAME=$DEFAULT_GIT_USER_NAME; echo ${GREEN}$GIT_USER_NAME${NC}; echo
  echo "Git user email [default: ${BLUE}$DEFAULT_GIT_USER_EMAIL${NC}]"; read -t $PROMPT_TIMEOUT -n 50 -sp "--> " GIT_USER_EMAIL ; [ -z "${GIT_USER_EMAIL}" ] && GIT_USER_EMAIL=$DEFAULT_GIT_USER_EMAIL; echo ${GREEN}$GIT_USER_EMAIL${NC}; echo
  echo "Delete all icons on Dock? [default: ${BLUE}$DEFAULT_DELETE_ALL_DOCK_ICONS${NC}] [y/N]"; read -t $PROMPT_TIMEOUT -n 1 -sp "--> " DELETE_ALL_DOCK_ICONS ; [ -z "${DELETE_ALL_DOCK_ICONS}" ] && DELETE_ALL_DOCK_ICONS=$DEFAULT_DELETE_ALL_DOCK_ICONS; echo ${GREEN}$DELETE_ALL_DOCK_ICONS${NC}; echo
  echo "Dotfiles source repository [default: ${BLUE}$DEFAULT_DOTFILES_SRC${NC}]"; read -t $PROMPT_TIMEOUT -n 200 -sp "--> " DOTFILES_SRC ; [ -z "${DOTFILES_SRC}" ] && DOTFILES_SRC=$DEFAULT_DOTFILES_SRC; echo ${GREEN}$DOTFILES_SRC${NC}; echo
  echo "Edit Brewfiles before installing? [default: ${BLUE}$DEFAULT_EDIT_BREWFILES${NC}] [y/N]"; read -t $PROMPT_TIMEOUT -n 1 -sp "--> " EDIT_BREWFILES ; [ -z "${EDIT_BREWFILES}" ] && EDIT_BREWFILES=$DEFAULT_EDIT_BREWFILES; echo ${GREEN}$EDIT_BREWFILES${NC}; echo
  echo "Install Essentials Bundle? [default: ${BLUE}$DEFAULT_INSTALL_BUNDLE_ESSENTIALS${NC}] [y/N]"; read -t $PROMPT_TIMEOUT -n 1 -sp "--> " INSTALL_BUNDLE_ESSENTIALS ; [ -z "${INSTALL_BUNDLE_ESSENTIALS}" ] && INSTALL_BUNDLE_ESSENTIALS=$DEFAULT_INSTALL_BUNDLE_ESSENTIALS; echo ${GREEN}$INSTALL_BUNDLE_ESSENTIALS${NC}; echo
  echo "Install Development Bundle? [default: ${BLUE}$DEFAULT_INSTALL_BUNDLE_DEVELOPMENT${NC}] [y/N]"; read -t $PROMPT_TIMEOUT -n 1 -sp "--> " INSTALL_BUNDLE_DEVELOPMENT ; [ -z "${INSTALL_BUNDLE_DEVELOPMENT}" ] && INSTALL_BUNDLE_DEVELOPMENT=$DEFAULT_INSTALL_BUNDLE_DEVELOPMENT; echo ${GREEN}$INSTALL_BUNDLE_DEVELOPMENT${NC}; echo
  echo "Install MS Office Bundle? [default: ${BLUE}$DEFAULT_INSTALL_BUNDLE_MSOFFICE${NC}] [y/N]"; read -t $PROMPT_TIMEOUT -n 1 -sp "--> " INSTALL_BUNDLE_MSOFFICE ; [ -z "${INSTALL_BUNDLE_MSOFFICE}" ] && INSTALL_BUNDLE_MSOFFICE=$DEFAULT_INSTALL_BUNDLE_MSOFFICE; echo ${GREEN}$INSTALL_BUNDLE_MSOFFICE${NC}; echo
  echo "Enter the git url for you private backup reporitory [default: ${BLUE}$DEFAULT_PRIVATE_DATA_BACKUP_REPO${NC}]"; read -t $PROMPT_TIMEOUT -n 400 -sp "--> " PRIVATE_DATA_BACKUP_REPO ; [ -z "${PRIVATE_DATA_BACKUP_REPO}" ] && PRIVATE_DATA_BACKUP_REPO=$DEFAULT_PRIVATE_DATA_BACKUP_REPO; echo ${GREEN}$PRIVATE_DATA_BACKUP_REPO${NC}; echo

  echo
  checkout_private_data_repository
}

set_default_values() {
  AUTOMATIC_SETUP_PACKAGE=$1

  echo
  echo "${GREEN}Deploying \c${NC}"

  case $AUTOMATIC_SETUP_PACKAGE in
    -l|--lean) echo "${GREEN}lean installation package... ${NC}"; DEFAULT_INSTALL_BUNDLE_ESSENTIALS='y' ;;
    -e|--express) echo "${GREEN}express installation package... ${NC}"; DEFAULT_INSTALL_BUNDLE_ESSENTIALS='y'; DEFAULT_INSTALL_BUNDLE_DEVELOPMENT='y' ;;
    -f|--full|*) echo "${GREEN}full installation package... ${NC}"; DEFAULT_INSTALL_BUNDLE_ESSENTIALS='y'; DEFAULT_INSTALL_BUNDLE_DEVELOPMENT='y'; DEFAULT_INSTALL_BUNDLE_MSOFFICE='y' ;;
  esac

 set_user_properties

  DELETE_ALL_DOCK_ICONS=$DEFAULT_DELETE_ALL_DOCK_ICONS
  DOTFILES_SRC=$DEFAULT_DOTFILES_SRC
  EDIT_BREWFILES=$DEFAULT_EDIT_BREWFILES
  INSTALL_BUNDLE_ESSENTIALS=$DEFAULT_INSTALL_BUNDLE_ESSENTIALS
  INSTALL_BUNDLE_DEVELOPMENT=$DEFAULT_INSTALL_BUNDLE_DEVELOPMENT
  INSTALL_BUNDLE_MSOFFICE=$DEFAULT_INSTALL_BUNDLE_MSOFFICE

  COMPUTER_NAME=$DEFAULT_COMPUTER_NAME
  HOSTNAME=$DEFAULT_HOSTNAME
  LOCAL_HOSTNAME=$DEFAULT_LOCAL_HOSTNAME
  GIT_USER_NAME=$DEFAULT_GIT_USER_NAME
  GIT_USER_EMAIL=$DEFAULT_GIT_USER_EMAIL
}

debug_setup() {
  echo "${GREEN}Running in debug mode... ${NC}"
  DEFAULT_DELETE_ALL_DOCK_ICONS='n'
  DELETE_ALL_DOCK_ICONS='n'
}

case $SETUP_MODE in
  -a|--automatic) set_default_values $SETUP_PACKAGE; interactive_setup 1 ;;
  -d|--debug) set_default_values $SETUP_PACKAGE; debug_setup; interactive_setup 1 ;;
  -m|--manual|*) set_default_values $SETUP_PACKAGE; interactive_setup 60 ;;
esac

# Create a time machine backup
echo
time_machine_backup

# Set computer name
sudo scutil --set ComputerName "${COMPUTER_NAME}"
sudo scutil --set HostName "${HOSTNAME}"
sudo scutil --set LocalHostName "${LOCAL_HOSTNAME}"
dscacheutil -flushcache

# Change settings for native apps and system
echo
sh utils/os-defaults.sh

# Cleanup default junk on dock
[[ ${DELETE_ALL_DOCK_ICONS} =~ ^[Yy]$ ]] && defaults delete com.apple.dock persistent-apps && defaults delete com.apple.dock persistent-others

# # Install Rosetta
# echo
# install_rosetta

# Tap homebrew/bundle
echo
echo "Tap homebrew/bundle... \c"
brew tap homebrew/bundle &>/dev/null
echo "Done"

# Fetch homebrew bundle files
echo
BREWFILES_SRC="$DOTFILES_SRC/raw/main/macOS/homebrew"
echo "Fetching Brewfiles from ${BLUE}$BREWFILES_SRC${NC} to $DEFAULT_BREWFILES_CHECHOUT_LOCATION ... \c"
rm -rf $DEFAULT_BREWFILES_CHECHOUT_LOCATION &>/dev/null && mkdir $DEFAULT_BREWFILES_CHECHOUT_LOCATION &>/dev/null
echo "Done"

# Installing Mac App Store CLI Support
echo
echo "Installing Mac App Store CLI Support... \c"
brew install mas &>/dev/null
echo "Done"

# Install Brewfiles
install_bundle $DEFAULT_BREWFILE_APP_STORE $INSTALL_BUNDLE_ESSENTIALS
install_bundle $DEFAULT_BREWFILE_ESSENTIALS $INSTALL_BUNDLE_ESSENTIALS
install_bundle $DEFAULT_BREWFILE_DEVELOPER $INSTALL_BUNDLE_DEVELOPMENT
install_bundle $DEFAULT_BREWFILE_MSOFFICE $INSTALL_BUNDLE_MSOFFICE

# Install oh-my-zsh and activate oh-my-zsh plugins
echo
sh utils/oh-my-zsh.sh

# Install powerlevel10k zsh theme
echo
sh utils/zsh-theme.sh

# Install zsh and activate zsh plugins
echo
sh utils/zsh.sh

# Install code editor
echo
sh utils/editor.sh -vscode

# Creating developer directory
echo
developer_dir

# # Set custom folder icons
# echo
# sh utils/folderify.sh

# Setup user's bin dir
echo
setup_user_bin_dir

# Restoring private backed up application and personal config files from cloud
echo
sh utils/mackup.sh --restore

# Configure ssh keys
echo
sh utils/ssh-keys.sh $GIT_USER_EMAIL

# # Install user apps from cloud backup
# echo
# sh utils/user-apps.sh

# Install java env manager
echo
# sh utils/sdk.sh -jdk temurin
sh utils/sdk.sh -jenv

# Install node version manager
echo
# sh utils/sdk.sh -node lts
sh utils/sdk.sh -nvm

# Configure git
echo
echo "Configuring Git..."
if test $(which git); then
  git config --global init.defaultBranch main
  git config --global core.editor $(which vi)
  git config --global credential.helper store
  git config --global merge.tool diffmerge
  git config --global merge.conflictstyle diff3
  git config --global mergetool.prompt false
  git config --global alias.co checkout
  git config --global alias.ci commit
  git config --global alias.br branch
  git config --global alias.st status
  git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"
  git config --global alias.tree "log --graph --full-history --all --color --date=short --pretty=format:'%Cred%x09%h %Creset%ad%Cblue%d %Creset %s %C(bold)(%an)%Creset'"
  [[ ! -z ${GIT_USER_NAME} ]] && echo "Setting GitHub global user name: $GIT_USER_NAME" && git config --global user.name "$GIT_USER_NAME"
  [[ ! -z ${GIT_USER_EMAIL} ]] && echo "Setting GitHub global user email: $GIT_USER_EMAIL" && git config --global user.email "$GIT_USER_EMAIL"
  [[ -f ~/.ssh/id_github ]] && echo "Setting GitHub global access protocol: ssh" && git config --global url."git@github.com:".insteadOf "https://github.com/"
fi

# Clone user's projects from version control
echo
sh utils/projects.sh

# # Enable installed services
# echo
# echo "Enabling installed services... \c"
#   # [ -e "/Applications/Rectangle.app" ] && open /Applications/Rectangle.app
#   # [ -e "/Applications/Hidden Bar.app" ] && open /Applications/Hidden Bar.app
#   # [ -e "/Applications/AdGuard.app" ] && open /Applications/AdGuard.app
# echo "Done"

echo
echo "${YELLOW}Thanks for using DevMyMacX!${NC}"
echo "${YELLOW}If you liked it, make sure to go to the GitHub repo (https://github.com/iamshgulati/DevMyMacX) and star it!${NC}"
echo "${YELLOW}If you have any issues, just put them there. All suggestions and contributions are appreciated!${NC}"

echo
echo "${RED}Some changes will be applied after closing this terminal window and logging off the user.${NC}"
