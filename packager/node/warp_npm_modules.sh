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

node_files=".node_version package.json"

if [ -e "npm-shrinkwrap.json" ]
then
  node_files="$node_files npm-shrinkwrap.json"
fi

run cp $node_files $TMPDIR

secure_cd $TMPDIR

nvm_command "nvm use v`cat .node_version` && npm install --production"

run rm $node_files

automatic_update_sys_dependencies $TMPDIR

run cp -r $WARP_HOME/common $TMPDIR

cat > $TMPDIR/install <<STOP_SUBSCRIPT
#!/bin/sh -e

common/check_dependencies.sh $SYS_DEPENDENCIES

echo "Extracting npm modules $LOCAL_NPM_MODULES_HASH to \${HOME}/.nvm/v$LOCAL_NODE_VERSION/modules/$LOCAL_NPM_MODULES_HASH"
mkdir -p \${HOME}/.nvm/v$LOCAL_NODE_VERSION/modules/$LOCAL_NPM_MODULES_HASH
rm -rf \${HOME}/.nvm/v$LOCAL_NODE_VERSION/modules/$LOCAL_NPM_MODULES_HASH
mv node_modules \${HOME}/.nvm/v$LOCAL_NODE_VERSION/modules/$LOCAL_NPM_MODULES_HASH

echo "Done."

STOP_SUBSCRIPT
check_result

run chmod +x $TMPDIR/install

secure_cd $WARP_EXPORT_DIR

run $WARP_HOME/warper/warp_builder.sh $TARGET_NAME $TMPDIR

run rm -rf $TMPDIR

