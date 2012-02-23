#!/bin/sh -e

SYNTAX="Syntax : $0 target_directory ruby_version_from_rbenv"


START_DIR=`pwd`

cd `dirname $0`
DIRNAME=`pwd`
WARP_HOME_SCRIPT=$DIRNAME/../../warper/warp_home_directory.sh

cd $START_DIR

TARGET_DIRECTORY=$1

if [ "$TARGET_DIRECTORY" = "" ]; then
  echo $SYNTAX
  exit 1
fi

if [ ! -d $TARGET_DIRECTORY ]; then
  echo "$TARGET_DIRECTORY does not exist : $RUBY_VERSION"
  exit 1
fi

shift

RUBY_VERSION=$1

if [ "$RUBY_VERSION" = "" ]; then
  echo $SYNTAX
  exit 1
fi

FROM="$HOME/.rbenv/versions/$RUBY_VERSION"

if [ ! -d $FROM ]; then
  echo "Ruby version does not exist : $RUBY_VERSION"
  exit 1
fi

shift

TARGET_NAME=`$DIRNAME/../../common/ruby/generate_ruby.sh $RUBY_VERSION`

cd  $TARGET_DIRECTORY

if [ -f ${TARGET_NAME}.warp ]; then
  echo "Already exist $TARGET_NAME, not repackaging"
  exit 0
fi

echo "Package ruby version from rbenv : $RUBY_VERSION"
echo "Using system dependencies : $*"

$WARP_HOME_SCRIPT $TARGET_NAME $FROM .rbenv/versions/$RUBY_VERSION $*