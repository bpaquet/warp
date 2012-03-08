#!/bin/sh

DIRNAME=`dirname $0`
RELATIVE_WARP_HOME=../
. $DIRNAME/$RELATIVE_WARP_HOME/common/shell_lib.sh

check_export_directory

SYNTAX="Syntax : $0 from_directory [home|absolute|current] target_directory warp_name [sys dependencies]"

FROM=$1
check_not_empty $FROM
check_directory_exists $FROM
shift

METHOD=$1
check_mutiple_values $METHOD home absolute current
shift

TO=$1
check_not_empty $TO
shift

TARGET_NAME=$1
check_not_empty $TARGET_NAME
shift

check_not_existent $WARP_EXPORT_DIR/$TARGET_NAME

SYS_DEPENDENCIES=$*

echo "Packaging directory $FROM to be installed into $METHOD:$TO"
echo "Warp name : $TARGET_NAME"
echo "Sys dependencies : $SYS_DEPENDENCIES"

TMPDIR=$(tmpdir)

run cp -r $FROM $TMPDIR/data

run cp -r $WARP_HOME/common $TMPDIR

case $METHOD in
  home)
    TO="\$HOME/$TO"
    ;;
  absolute)
    ;;
  current)
    TO="\$1/$TO"
    ;;
esac

cat > $TMPDIR/install <<STOP_SUBSCRIPT
#!/bin/sh -e

common/check_dependencies.sh $SYS_DEPENDENCIES

echo "Extracting to $TO"
mkdir -p $TO
rm -rf $TO
mv data $TO

echo "Done."

STOP_SUBSCRIPT
check_result

run chmod +x $TMPDIR/install

secure_cd $WARP_EXPORT_DIR

run $WARP_HOME/warper/warp_builder.sh $TARGET_NAME $TMPDIR

run rm -rf $TMPDIR
