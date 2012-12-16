#!/bin/sh

TARGET=$1

LIST=`(
  find $TARGET -name '*.so' -exec ldd {} \;
  find $TARGET -executable -type f -exec ldd {} \;
) | grep '=>' | grep -v 'not found' | awk '{print $3}' | grep -v '^(0x' | sort | uniq`

TMP_FILE=`mktemp`

for i in $LIST; do
  if [ `which dpkg 2>&1 2> /dev/null` ]; then
    X=`dpkg -S $i 2> /dev/null | awk -F: '{print $1}'`
  else
    X=`rpm -q --queryformat '%{NAME}\n' --whatprovides $i`
  fi
  if [ $? = 0 ]; then
    echo $X >> $TMP_FILE
  fi
done

cat $TMP_FILE | sort | uniq | perl -pe 's/\n/ /g'

rm $TMP_FILE
