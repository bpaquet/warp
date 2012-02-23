#!/bin/sh -e

SYNTAX="Syntax : $0 target_directory ruby_version_from_rbenv"

DIRNAME=`dirname $0`

TARGET_DIRECTORY=$1


if [ "$TARGET_DIRECTORY" = "" ]; then
  echo $SYNTAX
  exit 1
fi

if [ ! -d $TARGET_DIRECTORY ]; then
  echo "$TARGET_DIRECTORY does not exist : $RUBY_VERSION"
  exit 1
fi

RUBY_VERSION=$2

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

cd  $TARGET_DIRECTORY

TARGET_NAME="ruby_`$DIRNAME/get_arch.sh`_$RUBY_VERSION"

if [ -f ${TARGET_NAME}.warp ]; then
  echo "Already exist $TARGET_NAME, not repackaging"
  exit 0
fi

echo "Package ruby version from rbenv : $RUBY_VERSION"
echo "Using system dependencies : $*"

$DIRNAME/../warper/warp_home_directory.sh $TARGET_NAME $FROM .rbenv/versions/$RUBY_VERSION $*