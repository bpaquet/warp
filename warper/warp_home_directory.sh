#!/bin/sh -e

SYNTAX="Syntax : $0 archive_name src_directory path_in_home_directory [system dependencies]"

START_DIR=`pwd`

cd `dirname $0`
DIRNAME=`pwd`
WARP_HOME=$DIRNAME/..

cd $START_DIR

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

if [ "$INSTALL_RBENV" = "1" ]; then
  echo "Rbenv will be automatically installed whith this package"
fi

TMPDIR=`mktemp -d /tmp/warp.XXXXXX`

mkdir -p $TMPDIR
cp -r $DIRECTORY $TMPDIR/data

EXTENDED_COMMAND_BEFORE=""
EXTENDED_COMMAND_AFTER=""

if [ "$INSTALL_RBENV" = "1" ]; then
  mkdir $TMPDIR/ruby
  cp $WARP_HOME/common/ruby/setup_rbenv.sh $TMPDIR/ruby
  cp $WARP_HOME/common/ruby/set_global_ruby_version.sh $TMPDIR/ruby
  EXTENDED_COMMAND_BEFORE=./ruby/setup_rbenv.sh
  EXTENDED_COMMAND_AFTER=./ruby/set_global_ruby_version.sh
fi

cat > $TMPDIR/install <<STOP_SUBSCRIPT
#!/bin/sh -e

./check_dependencies.sh $SYS_DEPENDENCIES

$EXTENDED_COMMAND_BEFORE

echo "Extracting data to \${HOME}/$PATH_IN_HOME_DIRECTORY"
mkdir -p \${HOME}/$PATH_IN_HOME_DIRECTORY
rm -rf \${HOME}/$PATH_IN_HOME_DIRECTORY
mv data \${HOME}/$PATH_IN_HOME_DIRECTORY
echo "Done."

$EXTENDED_COMMAND_AFTER

STOP_SUBSCRIPT

chmod +x $TMPDIR/install

cp $WARP_HOME/common/check_dependencies.sh $TMPDIR

$DIRNAME/warp_builder.sh $ARCHIVE_NAME $TMPDIR

rm -rf $TMPDIR