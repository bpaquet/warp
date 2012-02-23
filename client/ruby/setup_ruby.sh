#!/bin/sh -e

DIRNAME=`dirname $0`

$DIRNAME/../../common/ruby/setup_rbenv.sh

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

rm -f $TARGET
set +e
curl -f -s $WARP_SRC/$FILENAME.warp -o $TARGET > /dev/null
RESULT=$?
set -e

if [ "$RESULT" != "0" ]; then
  echo "Unable to download file $WARP_SRC/$FILENAME.warp"
  exit 1
fi

sh $TARGET
rm $TARGET