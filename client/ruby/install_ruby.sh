#!/bin/sh

DIRNAME=`dirname $0`
RELATIVE_WARP_HOME=../../
. $DIRNAME/$RELATIVE_WARP_HOME/common/shell_lib.sh

load_lib ruby

assert_rbenv_installed

check_existent .rbenv-version

load_ruby_config

if [ -d $RBENV_DIR/versions/$LOCAL_RUBY_VERSION ]; then
  echo "Ruby $LOCAL_RUBY_VERSION is already installed"
  exit 0  
fi

TARGET_NAME=$(generate_ruby_version $LOCAL_RUBY_VERSION)

echo "Ruby version $LOCAL_RUBY_VERSION is not installed"

download_and_install $TARGET_NAME
