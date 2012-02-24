#!/bin/sh -e

NAME="ruby_`lsb_release -cs`_`arch`_$1"

if [ "$INSTALL_RBENV" = "1" ]; then
  NAME="${NAME}_rbenv"
fi

echo $NAME