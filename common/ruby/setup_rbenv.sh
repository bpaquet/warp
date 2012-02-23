#!/bin/sh -e

DIRNAME=`dirname $0`
$DIRNAME/../check_dependencies.sh git-core curl | grep -v Checking || true

RBENV_TAG="v0.3.0"
RBENV_RUBY_BUILD_TAG="v20120216"
RBENV_GEMSET_TAG="v0.3.0"

cd $HOME
if [ ! -d .rbenv ]; then
  git clone git://github.com/sstephenson/rbenv.git .rbenv
fi
cd .rbenv
CURRENT_TAG=`git log --decorate -1 | grep $RBENV_TAG || true`
if [ "$CURRENT_TAG" = "" ]; then
  echo "Updating rbenv"
  git checkout master
  git pull
  git fetch --tags
  git checkout $RBENV_TAG
fi

mkdir -p $HOME/.rbenv/plugins
cd $HOME/.rbenv/plugins/

if [ ! -d ruby-build ]; then
  git clone git://github.com/sstephenson/ruby-build.git
fi
cd ruby-build
CURRENT_TAG=`git log --decorate -1 | grep $RBENV_RUBY_BUILD_TAG || true`
if [ "$CURRENT_TAG" = "" ]; then
  echo "Updating rbenv ruby build"
  git checkout master
  git pull
  git fetch --tags
  git checkout $RBENV_RUBY_BUILD_TAG
fi

if [ ! -d rbenv-gemset ]; then
  git clone git://github.com/jamis/rbenv-gemset.git
fi
cd rbenv-gemset
CURRENT_TAG=`git log --decorate -1 | grep $RBENV_GEMSET_TAG || true`
if [ "$CURRENT_TAG" = "" ]; then
  echo "Updating rbenv gemset"
  git checkout master
  git pull
  git fetch --tags
  git checkout $RBENV_GEMSET_TAG
fi
