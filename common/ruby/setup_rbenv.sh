#!/bin/sh -e

echo "Installing Rbenv."

DIRNAME=`dirname $0`
$DIRNAME/../check_dependencies.sh git-core curl

cd $HOME
git clone git://github.com/sstephenson/rbenv.git .rbenv
mkdir -p $HOME/.rbenv/plugins
cd $HOME/.rbenv/plugins/
git clone git://github.com/sstephenson/ruby-build.git

echo "Rbenv installed."