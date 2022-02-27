#!/bin/sh

# Input variables
SDK=$1
SDK_VERSION=$2

setup_jdk () {
    echo "Setting up method to switch between different jdk versions... \c"
    if ! test $(which javac) || [ ! "$(ls /Library/Java/JavaVirtualMachines)" ]; then
        echo "Maybe install a jdk first."
        exit 1
    fi
    [ ! -f $HOME/.zshenv ] && touch $HOME/.zshenv
    if ! grep -Fq "jdk()" ~/.zshenv; then
        {
            echo ''
            echo 'jdk() {'
            echo '  jdk_version=$1'
            echo '  export JAVA_HOME=$(/usr/libexec/java_home -v"$jdk_version");'
            echo '  java -version'
            echo '}'
        } >> ~/.zshenv
    fi
    echo "Done"

    echo "List of JDK versions installed... \c"
    ls /Library/Java/JavaVirtualMachines
}

setup_nvm () {
    echo "Installing nvm... \c"
    if ! test $(command -v nvm); then
        brew install nvm &>/dev/null
    fi
    [ ! -d $HOME/.nvm ] && mkdir $HOME/.nvm &>/dev/null
    if ! grep -q '. "/opt/homebrew/opt/nvm/nvm.sh"' ~/.zshrc; then
        {
            echo ''
            echo 'export NVM_DIR="$HOME/.nvm"'
            echo '[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"'
            echo '[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"'
        } >> ~/.zshrc
    fi
    echo "Done"

    export NVM_DIR="$HOME/.nvm"
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
    eval $(/opt/homebrew/bin/brew shellenv) &>/dev/null
}

setup_node () {
    NODE_VERSION=${1}
    if ! test $(command -v nvm); then setup_nvm; fi

    echo "Intalling node\c"
    if [ ${NODE_VERSION} = "lts" ]; then
        echo " lts version through nvm... \c"
        nvm install --lts &>/dev/null
        nvm use --lts &>/dev/null
    else
        echo " current version through nvm... \c"
        nvm install node &>/dev/null
        nvm use node &>/dev/null
    fi

    echo "Clearing nvm cache... \c"
    nvm cache clear &>/dev/null

    echo "Done"

    echo "List of node versions installed... \c"
    ls $HOME/.nvm/versions/node

    # NPM Settings
    # npm config set loglevel warn &>/dev/null
}

while [[ "$#" -gt 0 ]]; do
    case $SDK in
        -jdk|--java-development-kit) setup_jdk; shift ;;
        -nvm|--node-version-manager) setup_nvm; shift ;;
        -node|--node) setup_node $SDK_VERSION; shift ;;
        *) echo "$0: Unknown parameter passed: $SDK"; exit 1 ;;
    esac
    shift
done