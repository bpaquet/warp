#!/bin/sh

DIRNAME=`dirname $0`
RELATIVE_WARP_HOME=../../
. $DIRNAME/$RELATIVE_WARP_HOME/common/shell_lib.sh

load_lib ruby

assert_rbenv_installed

if [ -f .warped ]; then
  echo "This project has already been warped !"
  exit 0
fi

check_existent Gemfile
check_existent Gemfile.lock
check_existent .rbenv-version
check_existent .rbenv-gemsets

load_ruby_config

TARGET_NAME=$(generate_gemset)

echo "Installing gemset $LOCAL_GEMSET $LOCAL_GEMSET_HASH"

finalize() {
  if [ -d $RBENV_DIR/versions/$LOCAL_RUBY_VERSION/gemsets/$LOCAL_GEMSET_HASH/.bundle ]; then
    cp -r $RBENV_DIR/versions/$LOCAL_RUBY_VERSION/gemsets/$LOCAL_GEMSET_HASH/.bundle .bundle
  fi
  echo $LOCAL_GEMSET_HASH > .rbenv-gemsets
  echo $LOCAL_GEMSET > .warped
}

if [ -d $RBENV_DIR/versions/$LOCAL_RUBY_VERSION/gemsets/$LOCAL_GEMSET_HASH ]; then
  echo "Gemset $LOCAL_GEMSET $LOCAL_GEMSET_HASH already present"
  finalize
  exit 0
fi

download_and_install $TARGET_NAME

finalize
