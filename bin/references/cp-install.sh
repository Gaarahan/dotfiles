#!/usr/bin/env bash

#Fork form https://github.com/glepnir/dotfiles

# include my library helpers for colorized echo and require_brew, etc
source ./utils.sh

# skip those GUI clients, git command-line all the way
require_brew git

bot "OK, now I am going to update the .gitconfig for your user info:"

gitfile="$HOME/.gitconfig"
running "link .gitconfig"
if [ ! -f "gitfile" ]; then
  read -r -p "Seems like your gitconfig file exist,do you want delete it? [y|N] " response
  if [[ $response =~ (y|yes|Y) ]]; then
    rm -rf $HOME/.gitconfig
    action "cp /git/.gitconfig ~/.gitconfig"
    sudo cp $HOME/.dotfiles/git/.gitconfig  $HOME/.gitconfig
    ln -s $HOME/.dotfiles/git/.gitignore  $HOME/.gitignore
    ok
  else
    ok "skipped"
  fi
fi
grep 'user = GITHUBUSER'  $HOME/.gitconfig > /dev/null 2>&1
if [[ $? = 0 ]]; then
    read -r -p "What is your git username? " githubuser

  fullname=`osascript -e "long user name of (system info)"`

  if [[ -n "$fullname" ]];then
    lastname=$(echo $fullname | awk '{print $2}');
    firstname=$(echo $fullname | awk '{print $1}');
  fi

  if [[ -z $lastname ]]; then
    lastname=`dscl . -read /Users/$(whoami) | grep LastName | sed "s/LastName: //"`
  fi
  if [[ -z $firstname ]]; then
    firstname=`dscl . -read /Users/$(whoami) | grep FirstName | sed "s/FirstName: //"`
  fi
  email=`dscl . -read /Users/$(whoami)  | grep EMailAddress | sed "s/EMailAddress: //"`

  if [[ ! "$firstname" ]]; then
    response='n'
  else
    echo  "I see that your full name is $COL_YELLOW$firstname $lastname$COL_RESET"
    read -r -p "Is this correct? [Y|n] " response
  fi

  if [[ $response =~ ^(no|n|N) ]]; then
    read -r -p "What is your first name? " firstname
    read -r -p "What is your last name? " lastname
  fi
  fullname="$firstname $lastname"

  bot "Great $fullname, "

  if [[ ! $email ]]; then
    response='n'
  else
    echo  "The best I can make out, your email address is $COL_YELLOW$email$COL_RESET"
    read -r -p "Is this correct? [Y|n] " response
  fi

  if [[ $response =~ ^(no|n|N) ]]; then
    read -r -p "What is your email? " email
    if [[ ! $email ]];then
      error "you must provide an email to configure .gitconfig"
      exit 1
    fi
  fi


  running "replacing items in .gitconfig with your info ($COL_YELLOW$fullname, $email, $githubuser$COL_RESET)"

  # test if gnu-sed or MacOS sed

  sed -i "s/GITHUBFULLNAME/$firstname $lastname/" ./git/.gitconfig > /dev/null 2>&1 | true
  if [[ ${PIPESTATUS[0]} != 0 ]]; then
    echo
    running "looks like you are using MacOS sed rather than gnu-sed, accommodating"
    sed -i '' "s/GITHUBFULLNAME/$firstname $lastname/"  $HOME/.gitconfig
    sed -i '' 's/GITHUBEMAIL/'$email'/'  $HOME/.gitconfig
    sed -i '' 's/GITHUBUSER/'$githubuser'/'  $HOME/.gitconfig
    ok
  else
    echo
    bot "looks like you are already using gnu-sed. woot!"
    sed -i 's/GITHUBEMAIL/'$email'/'  $HOME/.gitconfig
    sed -i 's/GITHUBUSER/'$githubuser'/'  $HOME/.gitconfig
  fi
fi


###########################################################
bot "update ruby"
###########################################################

RUBY_CONFIGURE_OPTS="--with-openssl-dir=`brew --prefix openssl` --with-readline-dir=`brew --prefix readline` --with-libyaml-dir=`brew --prefix libyaml`"
require_brew ruby

# ###########################################################
bot "zsh setup"
# ###########################################################

require_brew zsh

# symslink zsh config
ZSHRC="$HOME/.zshrc"
running "Configuring zsh"
if [ ! -f "ZSHRC" ]; then
  read -r -p "Seems like your zshrc file exist,do you want delete it? [y|N] " response
  if [[ $response =~ (y|yes|Y) ]]; then
    rm -rf $HOME/.zshrc
    rm -rf $HOME/.zshenv
    action "link zsh/.zshrc and zsh/.zshenv"
    ln -s  $HOME/.dotfiles/zsh/.zshenv $HOME/.zshenv
    ln -s  $HOME/.dotfiles/zsh/.zshrc $HOME/.zshrc
    ln -s  $HOME/.dotfiles/zsh/.p10k-evilball.zsh $HOME/.p10k-evilball.zsh
    if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
      print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
      command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
      command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
        print -P "%F{160}▓▒░ The clone has failed.%f"
    fi
    zinit install
  else
    ok "skipped"
  fi
fi