#!/bin/sh

DIRNAME=`dirname $0`
RELATIVE_WARP_HOME=../../
. $DIRNAME/$RELATIVE_WARP_HOME/common/shell_lib.sh

load_lib ruby

RBENV_TAG="v0.3.0"
RBENV_RUBY_BUILD_TAG="v20120216"
RBENV_GEMSET_TAG="v0.3.0"

RBENV_HAS_BEEN_INSTALLED=0

secure_cd $HOME

if [ ! -d .rbenv ]; then
  echo "Cloning rbenv"
  run git clone http://github.com/sstephenson/rbenv.git .rbenv
  RBENV_HAS_BEEN_INSTALLED=1
fi

secure_cd .rbenv

CURRENT_TAG=`git log --decorate -1 | grep $RBENV_TAG`
if [ "$CURRENT_TAG" = "" ]; then
  echo "Updating rbenv"
  run git checkout master
  run git pull
  run git checkout $RBENV_TAG
fi

[ ! -d $RBENV_DIR/plugins ] && run mkdir -p $RBENV_DIR/plugins

secure_cd $RBENV_DIR/plugins/

if [ ! -d ruby-build ]; then
  run git clone http://github.com/sstephenson/ruby-build.git
fi

secure_cd ruby-build

CURRENT_TAG=`git log --decorate -1 | grep $RBENV_RUBY_BUILD_TAG`
if [ "$CURRENT_TAG" = "" ]; then
  echo "Updating rbenv ruby build"
  run git checkout master
  run git pull
  run git checkout $RBENV_RUBY_BUILD_TAG
fi

secure_cd ..

if [ ! -d rbenv-gemset ]; then
  run git clone http://github.com/jamis/rbenv-gemset.git
fi

secure_cd rbenv-gemset

CURRENT_TAG=`git log --decorate -1 | grep $RBENV_GEMSET_TAG`
if [ "$CURRENT_TAG" = "" ]; then
  echo "Updating rbenv gemset"
  run git checkout master
  run git pull
  run git checkout $RBENV_GEMSET_TAG
fi

$WARP_HOME/common/ruby/install_warp_plugin.sh
check_result

if [ "$RBENV_HAS_BEEN_INSTALLED" = "1" ]; then
  for i in $HOME/.bashrc $HOME/.bash_profile $HOME/.zshrc; do
    if [ -f $i ]; then
      FOUND=`cat $i | grep 'rbenv init'`
      if [ "$FOUND" = "" ]; then
        echo "Modifying shell file : $i"
        echo "" >> $i
        check_result
        echo "# RBENV CONFIG" >> $i
        echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> $i
        echo 'eval "$(rbenv init -)"' >> $i
      else
        echo "Startup files already modified"
      fi
      RBENV_HAS_BEEN_INSTALLED=0
    fi
  done
fi
if [ "$RBENV_HAS_BEEN_INSTALLED" = "1" ]; then
  echo "*****************************"
  echo "rbenv has been installed, but we do not found your shell startup scripts"
  echo "To activate it in your shell, please add following lines to your startup script"
  echo ""
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"'
  echo 'eval "$(rbenv init -)"'
  echo "*****************************"
fi
