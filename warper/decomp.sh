#!/bin/sh


START_DIR=`pwd`

TMPDIR=`mktemp -d /tmp/warp.XXXXXX`

echo ""
echo "This is a WARP self extracting installer"
echo "Using temp directory $TMPDIR"
echo ""

ARCHIVE=`awk '/^__ARCHIVE_BELOW__/ {print NR + 1; exit 0; }' $0`

tail -n+$ARCHIVE $0 | tar xj -C $TMPDIR

CDIR=`pwd`

cd $TMPDIR
./install $START_DIR
RESULT=$?

cd $CDIR
rm -rf $TMPDIR

exit $RESULT

__ARCHIVE_BELOW__
