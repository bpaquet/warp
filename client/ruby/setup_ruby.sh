#!/bin/sh -e

DIRNAME=`dirname $0`

if [ ! -d $HOME/.rbenv ]; then
  $DIRNAME/../../common/ruby/setup_rbenv.sh
fi

if [ ! -f .rbenv-version ]; then
  echo "No rbenv-version file"
  exit 1
fi

RUBY_VERSION=`cat .rbenv-version`

if [ -d $HOME/.rbenv/versions/$RUBY_VERSION ]; then
  exit 0  
fi

echo "Missing ruby version $RUBY_VERSION, installing it"

WARP_SRC=`cat $HOME/.warp_src`

FILENAME=`$DIRNAME/../../common/ruby/generate_ruby.sh $RUBY_VERSION`

TARGET=/tmp/$FILENAME.warp

curl -s $WARP_SRC/$FILENAME.warp > $TARGET
sh $TARGET
rm $TARGET