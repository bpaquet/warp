#!/bin/sh -e

START_DIR=`pwd`

cd `dirname $0`
DIRNAME=`pwd`
DECOMP_SCRIPT=$DIRNAME/decomp.sh

cd $START_DIR

NAME=$1
DIRECTORY=$2

SYNTAX="$0 archive_name directory"

if [ "$NAME" = "" ]; then
  echo $SYNTAX
  exit 1
fi
if [ ! -d $DIRECTORY ]; then
  echo $SYNTAX
  exit 1
fi

echo "Creating self extracting archive $NAME from $DIRECTORY"

ARCHIVE=$START_DIR/$NAME.tar.gz
BSX=$START_DIR/$NAME.bsx

cd $DIRECTORY

tar czf $ARCHIVE ./*

cat $DECOMP_SCRIPT $ARCHIVE > $BSX
rm $ARCHIVE

chmod +x $BSX

echo $NAME.bsx created.
