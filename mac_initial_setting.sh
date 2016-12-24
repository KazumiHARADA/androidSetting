#!/bin/bash

NORMAL=$(tput sgr0)
GREEN=$(tput setaf 2; tput bold)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)

export HOMEBREW_CASK_OPTS="--appdir=/Applications"

function section() {
    echo --------------------------------
    echo "$1"
    echo --------------------------------
}

function subsection() {
    echo "*** $1"
}

function successLog() {
    echo "$GREEN[Success] $1$NORMAL"
}

function warnLog() {
    echo "$YELLOW[Warning] $1$NORMAL"
}

function errorLog() {
    echo "$RED[Error] $1$NORMAL"
}

function copy() {
    if [ -e $1 ]; then
	cp $1 $2
	successLog "$3 copy $1 $2"
    else
	errorLog "$3 copy failed"
    fi
}

function sudo_makedir() {
    if [ -e $1 ]; then
	warnLog "$1 already exists"
    else
	sudo mkdir $1
	successLog "$1 create"
    fi
}


section "start mac initial setting"

subsection "shell setting"
read -p "*** input dot files root full path : " DOT_PATH
copy $DOT_PATH/dot_bashrc $HOME/.bashrc .bashrc
copy $DOT_PATH/dot_bash_profile $HOME/.bash_profile .bash_profile
copy $DOT_PATH/dotgit-completion.bash $HOME/.git-completion.bash .git_completion.bash

subsection "start homebrew install"
if [ `which brew` ]; then
    warnLog "skip homebrew"
else
    sudo_makedir /usr/local
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    if [ `which brew` ]; then
	successLog "homebrew install"
    else
	errorLog "homebrew install failed"
    fi
fi

subsection "start brew cask brewdle"
if [ `which brew` ]; then
    brew install caskroom/cask/brew-cask
    brew install argon/mas/mas
    brew tap Homebrew/bundle
    brew update
else
    errorLog "homebrew not found"
fi


brew bundle install








