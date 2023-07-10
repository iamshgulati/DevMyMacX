#!/bin/sh

# Variables
DEFAULT_PRIVATE_DATA_CHECKOUT_LOCATION=$HOME/.backup

get_user_property () {
  PROPERTY_KEY=$1
  grep -w "^${PROPERTY_KEY}" conf/user.properties|cut -d'=' -f2
}

get_env_property () {
  PROPERTY_KEY=$1
  grep -w "^${PROPERTY_KEY}" conf/environment.properties|cut -d'=' -f2
}

set_bootstrap_properties () {
  export SETUP_STATE=$(get_env_property 'SETUP_STATE')
  export SETUP_MODE=$(get_env_property 'SETUP_MODE')
  export SETUP_PACKAGE=$(get_env_property 'SETUP_PACKAGE')
}

set_user_properties () {
  export DEFAULT_COMPUTER_NAME=$(get_user_property 'COMPUTER_NAME')
  export DEFAULT_HOSTNAME=$(get_user_property 'HOSTNAME')
  export DEFAULT_LOCAL_HOSTNAME=$(get_user_property 'LOCAL_HOSTNAME')
  export DEFAULT_GIT_USER_NAME=$(get_user_property 'GIT_USER_NAME')
  export DEFAULT_GIT_USER_EMAIL=$(get_user_property 'GIT_USER_EMAIL')
  export DEFAULT_DOTFILES_SRC=$(get_user_property 'DOTFILES_SRC')
  export DEFAULT_PRIVATE_DATA_BACKUP_REPO=$(get_user_property 'PRIVATE_DATA_BACKUP_REPO')

  export CURRENT_PROJECTS_DIR=$(get_user_property 'CURRENT_PROJECTS_DIR')
  export GITHUB_USERNAME=$(get_user_property 'GITHUB_USERNAME')
  export CHECKOUT_GITHUB_PROJECTS=$(get_user_property 'CHECKOUT_GITHUB_PROJECTS')
}

checkout_private_data_repository () {
  if [ ! -d "${DEFAULT_PRIVATE_DATA_CHECKOUT_LOCATION}" ]; then
    echo "Cloning user's private backup to $DEFAULT_PRIVATE_DATA_CHECKOUT_LOCATION..."
    echo
    git clone $PRIVATE_DATA_BACKUP_REPO $DEFAULT_PRIVATE_DATA_CHECKOUT_LOCATION
  else
    echo "User's private backup found at $DEFAULT_PRIVATE_DATA_CHECKOUT_LOCATION..."
  fi
}

install_bundle() {
  BREWFILE=$1
  INSTALL_BUNDLE=$2
  if [[ ${INSTALL_BUNDLE} =~ ^[Yy]$ ]]; then
      curl -Ls $BREWFILES_SRC/$BREWFILE > $DEFAULT_BREWFILES_CHECHOUT_LOCATION/$BREWFILE
      [[ ${EDIT_BREWFILES} =~ ^[Yy]$ ]] && nano $DEFAULT_BREWFILES_CHECHOUT_LOCATION/$BREWFILE
      echo
      echo "Installing ${GREEN}$BREWFILE${NC}... "
      brew bundle --file=$DEFAULT_BREWFILES_CHECHOUT_LOCATION/$BREWFILE
  fi
}

time_machine_backup() {
  echo "Creating local time machine snapshot before making changes... \c"
  sudo tmutil localsnapshot &>/dev/null
  echo "Done"
}

check_cli_tools_installed() {
  if ! (type xcode-select >&- && xpath=$( xcode-select --print-path ) && test -d "${xpath}" && test -x "${xpath}") ; then
    echo "${RED}Need to install the XCode Command Line Tools (or XCode) first! Starting install...${NC}"
    # Install XCode Command Line Tools
    xcode-select --install &>/dev/null
    exit 1

    # System update causes Command Line Tools install failures and gets resolved with below command
    # sudo rm -rf `xcode-select -p`
    # xcode-select --install
    # sudo xcode-select -r
fi
}

install_rosetta() {
  echo "Installing Rosetta... \c"
  if [[ $(sysctl -n machdep.cpu.brand_string)="*Apple*" && $(launchctl list | grep "com.apple.oahd-root-helper") == "" ]]; then
      sudo softwareupdate --install-rosetta --agree-to-license &>/dev/null
  fi
  echo "Done"
}

developer_dir() {
  echo "Creating developer directory... \c"
  # mkdir -p $HOME/{Developer/{Workspace/{IntelliJIDEA,DataGrip,WebStorm,VSCode,Postman/files,iMovie},Projects/{Archive,Current},Source/{Bitbucket,GitHub,GitLab}},Sync} &>/dev/null
  mkdir -p $HOME/Developer &>/dev/null
  echo "Done"
}

developer_dir_tree() {
  echo "Creating developer directory tree... \c"
  mkdir -p $HOME/{Developer/{Workspace/{IntelliJIDEA,DataGrip,WebStorm,VSCode,Postman/files,iMovie},Projects/{Archive,Current},Source/{Bitbucket,GitHub,GitLab}},Sync} &>/dev/null
  echo "Done"
}

setup_user_bin_dir() {
  echo "Create user's bin directory and add to path... \c"
  [ ! -d $HOME/.bin ] && mkdir $HOME/.bin
  if ! grep -q '$HOME/.bin:$PATH' ~/.zshrc ; then
    {
      echo ''
      echo '# add user bin dir to path'
      echo 'export PATH=$HOME/.bin:$PATH'
    } >> ~/.zshrc
  fi
  echo "Done"
}
