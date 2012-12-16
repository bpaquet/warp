#!/bin/sh

TARGET=$1

if [ `which dpkg 2>&1 2> /dev/null` ]; then
  (
    find $TARGET -name '*.so' -exec ldd {} \;
    find $TARGET -executable -type f -exec ldd {} \;
  ) | grep '=>' | grep -v 'not found' | awk '{print $3}' | grep -v '^(0x' | sort | uniq | xargs dpkg -S  2> /dev/null | awk -F: '{print $1}' | sort | uniq | perl -pe 's/\n/ /g'
else
  LIST=`(
    find $TARGET -name '*.so' -exec ldd {} \;
    find $TARGET -executable -type f -exec ldd {} \;
  ) | grep '=>' | grep -v 'not found' | awk '{print $3}' | grep -v '^(0x' | sort | uniq`
  TMP_FILE=`mktemp`
  for i in $LIST; do
    X=`rpm -q --queryformat '%{NAME}\n' --whatprovides $i`
    if [ $? = 0 ]; then
      echo $X >> $TMP_FILE
    fi
  done
  cat $TMP_FILE | sort | uniq | perl -pe 's/\n/ /g'
  rm $TMP_FILE
fi
