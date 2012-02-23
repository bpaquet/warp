#!/bin/sh -e

SYNTAX="Syntax : $0 archive_name src_directory path_in_home_directory [system dependencies]"

DIRNAME=`dirname $0`

ARCHIVE_NAME=$1
if [ "$ARCHIVE_NAME" = "" ]; then
  echo $SYNTAX
  exit 1
fi

shift

DIRECTORY=$1
if [ ! -d $DIRECTORY ]; then 
  echo $SYNTAX
  exit 1
fi

shift

PATH_IN_HOME_DIRECTORY=$1
if [ "$PATH_IN_HOME_DIRECTORY" = "" ]; then
  echo $SYNTAX
  exit 1
fi

shift
SYS_DEPENDENCIES=$*


echo "Creating WARP archive for home directory"
echo "Archive name : $ARCHIVE_NAME"
echo "From : $DIRECTORY"
echo "Target path in home directory : $PATH_IN_HOME_DIRECTORY"
echo "System dependencies : $SYS_DEPENDENCIES"

TMPDIR=`mktemp -d /tmp/warp.XXXXXX`

mkdir -p $TMPDIR
cp -r $DIRECTORY $TMPDIR/data

cat > $TMPDIR/install <<STOP_SUBSCRIPT
#!/bin/sh -e

./check_dependencies.sh $SYS_DEPENDENCIES

echo "Extracting data to \${HOME}/$PATH_IN_HOME_DIRECTORY"
mkdir -p \${HOME}/$PATH_IN_HOME_DIRECTORY
rm -rf \${HOME}/$PATH_IN_HOME_DIRECTORY
mv data \${HOME}/$PATH_IN_HOME_DIRECTORY
echo "Done."

STOP_SUBSCRIPT

#cat $TMPDIR/install
chmod +x $TMPDIR/install

cp $DIRNAME/check_dependencies.sh $TMPDIR

$DIRNAME/warp_builder.sh $ARCHIVE_NAME $TMPDIR

rm -rf $TMPDIR