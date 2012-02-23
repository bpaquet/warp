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
  echo "$TARGET_DIRECTORY does not exist"
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

TMPDIR=`mktemp -d /tmp/warp.XXXXXX`

cp -r $FROM $TMPDIR

FROM=$TMPDIR/$RUBY_VERSION

if [ -d $FROM/gemsets ]; then
  if [ "$PACKAGE_GEMSETS" != "1" ]; then
    echo "************************************"
    echo "You have gemsets installed in this ruby. This package will not contains this gemsets."
    echo "If you want to include this gemsets into the package, please set env variable to PACKAGE_GEMSETS=1"
    echo "************************************"
    rm -rf $FROM/gemsets
  fi
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

rm -rf $FROM