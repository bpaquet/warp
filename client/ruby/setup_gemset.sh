#!/bin/sh -e

SYNTAX="Syntax : $0"
DIRNAME=`dirname $0`

if [ -f .warped ]; then
  exit 0
fi

if [ ! -f Gemfile.lock ]; then
  echo "No Gemfile.lock"
  exit 1
fi

if [ ! -f .rbenv-version ]; then
  echo "No .rbenv-version file"
  exit 1
fi
RUBY_VERSION=`cat .rbenv-version`

if [ ! -f .rbenv-gemsets ]; then
  echo "No .rbenv-gemsets file"
  exit 1
fi
GEMSET=`cat .rbenv-gemsets`

HASH=`$DIRNAME/../../common/ruby/generate_gemset.sh`

echo "Using gemset $HASH"

if [ -d $HOME/.rbenv/versions/$RUBY_VERSION/gemsets/$HASH ]; then
  echo "Gemset $HASH already present"
  echo "$GEMSET" > .warped
  echo "$HASH" > .rbenv-gemsets
  if [ -d $HOME/.rbenv/versions/$RUBY_VERSION/gemsets/$HASH/.bundle ]; then
    cp -r $HOME/.rbenv/versions/$RUBY_VERSION/gemsets/$HASH/.bundle .bundle
  fi
  exit 0
fi

FILENAME="gemset_${RUBY_VERSION}_${HASH}"

echo "Filename to download : $FILENAME"

WARP_SRC=`cat $HOME/.warp_src`

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

if [ -d $HOME/.rbenv/versions/$RUBY_VERSION/gemsets/$HASH/.bundle ]; then
  cp -r $HOME/.rbenv/versions/$RUBY_VERSION/gemsets/$HASH/.bundle .bundle
fi

echo "$GEMSET" > .warped
echo "$HASH" > .rbenv-gemsets