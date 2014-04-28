#!/bin/sh

SYS_DEPENDENCIES=$*

if [ "$NO_CHECK_SYS_DEPENDENCIES" != "" ]; then
  exit 0
fi

TO_BE_INSTALLED=""

for i in $SYS_DEPENDENCIES; do
  echo "Checking system dependency : $i"
  if [ `which dpkg 2> /dev/null` ]; then
    RES=$(dpkg -l $i | grep "^.i")
    if [ "$RES" = "" ]; then
      TO_BE_INSTALLED="$TO_BE_INSTALLED $i"
    fi
  else
    RES=$(rpm -q $i)
    if [ $? != 0 ]; then
      TO_BE_INSTALLED="$TO_BE_INSTALLED $i"
    fi
  fi
done

if [ "$TO_BE_INSTALLED" != "" ]; then
  if [ `which dpkg 2> /dev/null` ]; then
    COMMAND=aptitude
  else
    COMMAND=yum
  fi
  echo "Failed : missing system dependencies. To remove this check, please set the environment variable NO_CHECK_SYS_DEPENDENCIES"
  echo "Please run : sudo ${COMMAND} install${TO_BE_INSTALLED}"
  exit 1
fi
