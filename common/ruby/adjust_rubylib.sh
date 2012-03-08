#!/bin/sh -e

DIRNAME=`dirname $0`
RELATIVE_WARP_HOME=../../
. $DIRNAME/$RELATIVE_WARP_HOME/common/shell_lib.sh

load_lib ruby

assert_rbenv_installed

SYNTAX="$0 path"

RUBY_PATH=$1
check_not_empty $RUBY_PATH
RUBY_LIB=$RUBY_PATH/bin/.rubylib

SLASH_RUBY_PATH=`cd $RUBY_PATH && pwd | sed -e 's/\//\\\\\//g'`

if [ -f $RUBY_LIB.orig ]; then
  echo "Adjusting ruby lib for $RUBY_PATH"
  cat $RUBY_LIB.orig | sed -e "s/:\/[^:]\+\/\.rbenv\/versions\/[^\/]\+\//:${SLASH_RUBY_PATH}\//g" | sed -e "s/^\/[^:]\+\/\.rbenv\/versions\/[^\/]\+\//${SLASH_RUBY_PATH}\//g" > $RUBY_LIB
fi
