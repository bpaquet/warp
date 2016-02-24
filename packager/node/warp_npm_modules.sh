#!/bin/sh

SYNTAX="Syntax : $0"

DIRNAME=`dirname $0`
RELATIVE_WARP_HOME=../../
. $DIRNAME/$RELATIVE_WARP_HOME/common/shell_lib.sh

load_lib node

check_export_directory

check_existent package.json

load_node_config

TARGET_NAME=$(generate_npm_modules)

TARGET_NAME="${TARGET_NAME}.warp"

exit_if_existent $WARP_EXPORT_DIR/$TARGET_NAME

read_sys_dependencies

echo "Packaging npm modules to $TARGET_NAME"
echo "System dependencies : $SYS_DEPENDENCIES"

TMPDIR=$(tmpdir)
run rsync --exclude node_modules -ah ./ $TMPDIR/

secure_cd $TMPDIR

OUT_DIR=".nvm/v$LOCAL_NODE_VERSION/modules/$LOCAL_NPM_MODULES_HASH"
if [ ! -d "$NVM_DIR/v$LOCAL_NODE_VERSION" ]; then
  OUT_DIR=".nvm/versions/node/v$LOCAL_NODE_VERSION/modules/$LOCAL_NPM_MODULES_HASH"
fi

if [ "$NODE_ENV" = "" ]; then
  NODE_ENV=production
fi

nvm_command "nvm use v`cat .nvmrc` && npm install --$NODE_ENV"

TMPDIR2=$(tmpdir)

run mv $TMPDIR/node_modules $TMPDIR2

secure_cd $TMPDIR2

run rm -rf $TMPDIR

automatic_update_sys_dependencies $TMPDIR2

run cp -r $WARP_HOME/common $TMPDIR2

cat > $TMPDIR2/install <<STOP_SUBSCRIPT
#!/bin/sh -e

common/check_dependencies.sh $SYS_DEPENDENCIES

echo "Extracting npm modules $LOCAL_NPM_MODULES_HASH to \${HOME}/$OUT_DIR"
rm -rf \${HOME}/$OUT_DIR
mkdir -p \${HOME}/$OUT_DIR
mv node_modules \${HOME}/$OUT_DIR/

echo "Done."

STOP_SUBSCRIPT
check_result

run chmod +x $TMPDIR2/install

secure_cd $WARP_EXPORT_DIR

run $WARP_HOME/warper/warp_builder.sh $TARGET_NAME $TMPDIR2

run rm -rf $TMPDIR2

