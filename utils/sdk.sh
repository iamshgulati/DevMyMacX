#!/bin/sh

# Input variables
SDK=$1
SDK_VERSION=$2

setup_jenv () {
    echo "Installing jenv... \c"
    if ! test $(command -v jenv); then
        brew install jenv &>/dev/null
    fi
    [ ! -d $HOME/.jenv ] && mkdir $HOME/.jenv &>/dev/null
    if ! grep -q '"$HOME/.jenv/bin:$PATH"' ~/.zshrc; then
        {
            echo ''
            echo '# activate java env manager'
            echo 'export PATH="$HOME/.jenv/bin:$PATH"'
            echo 'eval "$(jenv init -)"'
        } >> ~/.zshrc
    fi
    echo "Done"

    export PATH="$HOME/.jenv/bin:$PATH"
    eval "$(jenv init -)" &>/dev/null
    jenv enable-plugin export &>/dev/null
    # jenv doctor
}

setup_jdk () {
    JDK_VERSION=${1}
    if ! test $(command -v jenv); then setup_jenv; fi

    echo "Installing jdk... \c"
    if ! test $(which javac) || [ ! "$(ls /Library/Java/JavaVirtualMachines)" ]; then
        brew install --cask ${JDK_VERSION}
    else
        echo "already installed... \c"
    fi

    echo "Done"

    echo "List of jdk versions installed... \c"
    ls -1 /Library/Java/JavaVirtualMachines

    echo "Adding installed jdk versions to jenv... \c"
    jenv add "$(/usr/libexec/java_home)"
    jenv versions

    # echo ${JAVA_HOME}
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
            echo '# activate node version manager'
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
        -jenv|--java-environment-manager) setup_jenv; shift ;;
        -jdk|--java-development-kit) setup_jdk $SDK_VERSION; shift ;;
        -nvm|--node-version-manager) setup_nvm; shift ;;
        -node|--node) setup_node $SDK_VERSION; shift ;;
        *) echo "$0: Unknown parameter passed: $SDK"; exit 1 ;;
    esac
    shift
done