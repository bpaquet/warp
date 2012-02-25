#!/bin/sh

DIRNAME=`dirname $0`
RELATIVE_WARP_HOME=../../
. $DIRNAME/$RELATIVE_WARP_HOME/common/shell_lib.sh

RBENV_TAG="v0.3.0"
RBENV_RUBY_BUILD_TAG="v20120216"
RBENV_GEMSET_TAG="v0.3.0"

RBENV_HAS_BEEN_INSTALLED=0

cd $HOME
check_result

if [ ! -d .rbenv ]; then
  echo "Cloning rbenv"
  run git clone git://github.com/sstephenson/rbenv.git .rbenv
  RBENV_HAS_BEEN_INSTALLED=1
fi

cd .rbenv
check_result

CURRENT_TAG=`git log --decorate -1 | grep $RBENV_TAG`
if [ "$CURRENT_TAG" = "" ]; then
  echo "Updating rbenv"
  run git checkout master
  run git pull
  run git checkout $RBENV_TAG
fi

[ ! -d $RBENV_DIR/plugins ] && run mkdir -p $RBENV_DIR/plugins

cd $RBENV_DIR/plugins/
check_result

if [ ! -d ruby-build ]; then
  run git clone git://github.com/sstephenson/ruby-build.git
fi

cd ruby-build
check_result

CURRENT_TAG=`git log --decorate -1 | grep $RBENV_RUBY_BUILD_TAG`
if [ "$CURRENT_TAG" = "" ]; then
  echo "Updating rbenv ruby build"
  run git checkout master
  run git pull
  run git checkout $RBENV_RUBY_BUILD_TAG
fi

cd ..
check_result

if [ ! -d rbenv-gemset ]; then
  run git clone git://github.com/jamis/rbenv-gemset.git
fi

cd rbenv-gemset
check_result

CURRENT_TAG=`git log --decorate -1 | grep $RBENV_GEMSET_TAG`
if [ "$CURRENT_TAG" = "" ]; then
  echo "Updating rbenv gemset"
  run git checkout master
  run git pull
  run git checkout $RBENV_GEMSET_TAG
fi

if [ "$RBENV_HAS_BEEN_INSTALLED" = "1" ]; then
  for i in $HOME/.bashrc $HOME/.bash_profile $HOME/.zshrc; do
    if [ -f $i ]; then
      FOUND=`cat $i | grep 'rbenv init'`
      if [ "$FOUND" = "" ]; then
        echo "Modifying shell file : $i"
        run echo "" >> $i
        run echo "# RBENV CONFIG" >> $i
        run echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> $i
        run echo 'eval "$(rbenv init -)"' >> $i
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
