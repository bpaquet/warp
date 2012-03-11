#!/bin/sh

SYS_DEPENDENCIES=$*

if [ "$NO_CHECK_SYS_DEPENDENCIES" != "" ]; then
  exit 0
fi

TO_BE_INSTALLED=""

for i in $SYS_DEPENDENCIES; do
  echo "Checking system dependency : $i"
  RES=$(dpkg -l $i | grep "^ii")
  if [ "$RES" = "" ]; then
    TO_BE_INSTALLED="$TO_BE_INSTALLED $i"
  fi
done

if [ "$TO_BE_INSTALLED" != "" ]; then
  echo "Failed : missing system dependencies. To remove this check, please set the environment variable NO_CHECK_SYS_DEPENDENCIES"
  echo "Please run : sudo aptitude install${TO_BE_INSTALLED}"
  exit 1
fi
