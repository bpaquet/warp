#!/bin/sh -e

SYS_DEPENDENCIES=$*

TO_BE_INSTALLED=""

for i in $SYS_DEPENDENCIES; do
  echo "Checking system dependency : $i"
  RES=$(dpkg -l $i | grep "^ii" || true)
  if [ "$RES" = "" ]; then
    TO_BE_INSTALLED="$TO_BE_INSTALLED $i"
  fi
done

if [ "$TO_BE_INSTALLED" != "" ]; then
  echo "Failed : missing system dependencies."
  echo "Please run : sudo aptitude install${TO_BE_INSTALLED}"
  exit 1
fi
