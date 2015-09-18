#!/bin/sh

SYNTAX="Syntax : $0 node_version_without_v"

DIRNAME=`dirname $0`
RELATIVE_WARP_HOME=../../
. $DIRNAME/$RELATIVE_WARP_HOME/common/shell_lib.sh

load_lib node

load_node_config

check_export_directory

if [ "$LOCAL_NODE_VERSION" != "" ]; then
  NODE_VERSION=$LOCAL_NODE_VERSION
else
  NODE_VERSION=$1
  check_not_empty $NODE_VERSION
  shift
fi

if [ "$1" = "-install_nvm" ]; then
  INSTALL_NVM=1
  shift
fi

# Compat with old nvm versions
FROM="$NVM_DIR/v$NODE_VERSION"
OUT_DIR=".nvm/v$NODE_VERSION"
if [ ! -d "$FROM" ]; then
  FROM="$NVM_DIR/versions/node/v$NODE_VERSION"
  OUT_DIR=".nvm/versions/node/v$NODE_VERSION"
fi
check_directory_exists $FROM

TARGET_NAME=$(generate_node_version $NODE_VERSION)

if [ "$INSTALL_NVM" = "1" ]; then
  TARGET_NAME="${TARGET_NAME}_nvm"
fi

TARGET_NAME="${TARGET_NAME}.warp"

exit_if_existent $WARP_EXPORT_DIR/$TARGET_NAME

read_sys_dependencies

echo "Package node version from nvm : $NODE_VERSION"
echo "System dependencies : $SYS_DEPENDENCIES"
echo "Installing nvm : $INSTALL_NVM"

TMPDIR=$(tmpdir)

run cp -r $FROM $TMPDIR

run rm -rf $TMPDIR/v$NODE_VERSION/modules

automatic_update_sys_dependencies $TMPDIR

run cp -r $WARP_HOME/common $TMPDIR

echo "#!/bin/sh -e" > $TMPDIR/install
echo "" >> $TMPDIR/install
echo "common/check_dependencies.sh $SYS_DEPENDENCIES" >> $TMPDIR/install

if [ "$INSTALL_NVM" = "1" ]; then
  echo "common/node/install_nvm.sh" >> $TMPDIR/install
fi

cat >> $TMPDIR/install <<STOP_SUBSCRIPT

echo "Extracting node $NVM_VERSION to \${HOME}/$OUT_DIR"
mkdir -p \${HOME}/$OUT_DIR
rm -rf \${HOME}/$OUT_DIR
mv v$NODE_VERSION \${HOME}/$OUT_DIR
common/node/adjust_shebangs.sh \${HOME}/$OUT_DIR

echo "New node version $NODE_VERSION installed"

echo "Done."

STOP_SUBSCRIPT
check_result

run chmod +x $TMPDIR/install

secure_cd $WARP_EXPORT_DIR

run $WARP_HOME/warper/warp_builder.sh $TARGET_NAME $TMPDIR

rm -rf $TMPDIR

