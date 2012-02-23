#!/bin/sh -e

SYNTAX="Syntax : $0 target_directory"

START_DIR=`pwd`

cd `dirname $0`
DIRNAME=`pwd`
WARP_HOME_SCRIPT=$DIRNAME/../../warper/warp_home_directory.sh
GENERATE_GEMSET=$DIRNAME/../../common/ruby/generate_gemset.sh

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

if [ ! -f Gemfile ]; then
  echo "No Gemfile"
  exit 1
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

echo "Warping gemset $GEMSET for ruby $RUBY_VERSION"

ORIG_GEMSET="$HOME/.rbenv/versions/$RUBY_VERSION/gemsets/$GEMSET"

if [ ! -d $ORIG_GEMSET ]; then
  echo "Missing gemset"
  exit 1
fi

shift

mv $ORIG_GEMSET $ORIG_GEMSET.old

START_DIR=`pwd`

TMPDIR=`mktemp -d /tmp/warp.XXXXXX`
cp .rbenv-version .rbenv-gemsets Gemfile $TMPDIR
cd $TMPDIR

gem install bundler
bundle $BUNDLE_OPTIONS

HASH=`$GENERATE_GEMSET`

TMPDIR2=`mktemp -d /tmp/warp.XXXXXX`

mv $ORIG_GEMSET $TMPDIR2
if [ -d .bundle ]; then
  mv .bundle $TMPDIR2/$GEMSET
fi

rm -rf $TMPDIR

mv $ORIG_GEMSET.old $ORIG_GEMSET

cd $TARGET_DIRECTORY

$WARP_HOME_SCRIPT "gemset_${RUBY_VERSION}_${HASH}" $TMPDIR2/$GEMSET .rbenv/versions/$RUBY_VERSION/gemsets/$HASH $*

rm -rf $TMPDIR2