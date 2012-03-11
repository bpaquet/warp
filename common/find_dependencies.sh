#!/bin/sh

TARGET=$1

(
  find $TARGET -name '*.so' -exec ldd {} \;
  find $TARGET -executable -type f -exec ldd {} \;
) | grep '=>' | grep -v 'not found' | awk '{print $3}' | grep -v '^(0x' | sort | uniq | xargs dpkg -S | awk -F: '{print $1}' | sort | uniq | perl -pe 's/\n/ /g'
 