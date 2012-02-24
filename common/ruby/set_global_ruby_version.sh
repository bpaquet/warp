#!/bin/sh -e

if [ "`ls $HOME/.rbenv/versions | wc -l`" = "1" ]; then
  VERSION=`ls $HOME/.rbenv/versions`
  echo "Only one ruby version detected : $VERSION"
  $HOME/.rbenv/bin/rbenv global $VERSION
  echo "Version $VERSION setted as global"
fi