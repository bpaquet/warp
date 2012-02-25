#!/bin/sh

DIRNAME=`dirname $0`
RELATIVE_WARP_HOME=../../
. $DIRNAME/$RELATIVE_WARP_HOME/common/shell_lib.sh

load_lib ruby

check_export_directory

check_existent Gemfile
check_existent Gemfile.lock
check_existent .rbenv-version
check_existent .rbenv-gemsets

load_ruby_config

TARGET_NAME=$(generate_gemset)

TARGET_NAME="${TARGET_NAME}.warp"

check_not_existent $WARP_EXPORT_DIR/$TARGET_NAME

SYS_DEPENDENCIES=$*

echo "Packaging gemset $LOCAL_GEMSET to $TARGET_NAME"
echo "Bundler options : $LOCAL_BUNDLE_OPTIONS"
echo "Sys dependencies : $SYS_DEPENDENCIES"

ORIG_GEMSET="$RBENV_DIR/versions/$LOCAL_RUBY_VERSION/gemsets/$LOCAL_GEMSET"
OLD_ORIG_GEMSET="${ORIG_GEMSET}.old"

if [ -d "$OLD_ORIG_GEMSET" ]; then
  run rm -rf $OLD_ORIG_GEMSET
fi

if [ -d "$ORIG_GEMSET" ]; then
  run mv $ORIG_GEMSET $OLD_ORIG_GEMSET
fi

TMPDIR=$(tmpdir)
run cp .rbenv-version .rbenv-gemsets Gemfile $TMPDIR

cd $TMPDIR
check_result

run gem install bundler
$RBENV_DIR/bin/rbenv rehash || true
run bundle $LOCAL_BUNDLE_OPTIONS
$RBENV_DIR/bin/rbenv rehash || true

TMPDIR2=$(tmpdir)

run mv $ORIG_GEMSET $TMPDIR2
if [ -d .bundle ]; then
  run mv .bundle $TMPDIR2/$LOCAL_GEMSET
fi

cd $TMPDIR2
check_result

run rm -rf $TMPDIR

run cp -r $WARP_HOME/common $TMPDIR2

if [ -d "$OLD_ORIG_GEMSET" ]; then
  run mv $OLD_ORIG_GEMSET $ORIG_GEMSET
fi

cat > $TMPDIR2/install <<STOP_SUBSCRIPT
#!/bin/sh -e

common/check_dependencies.sh $SYS_DEPENDENCIES

echo "Extracting gemset $LOCAL_GEMSET to \${HOME}/.rbenv/versions/$LOCAL_RUBY_VERSION/gemsets/$LOCAL_GEMSET_HASH"
mkdir -p \${HOME}/.rbenv/versions/$LOCAL_RUBY_VERSION/gemsets/$LOCAL_GEMSET_HASH
rm -rf \${HOME}/.rbenv/versions/$LOCAL_RUBY_VERSION/gemsets/$LOCAL_GEMSET_HASH
mv $LOCAL_GEMSET \${HOME}/.rbenv/versions/$LOCAL_RUBY_VERSION/gemsets/$LOCAL_GEMSET_HASH

\${HOME}/.rbenv/bin/rbenv rehash || true
common/ruby/adjust_shebangs.sh \${HOME}/.rbenv/versions/$LOCAL_RUBY_VERSION/gemsets/$LOCAL_GEMSET_HASH

echo "Done."

STOP_SUBSCRIPT

run chmod +x $TMPDIR2/install

cd $WARP_EXPORT_DIR
check_result

run $WARP_HOME/warper/warp_builder.sh $TARGET_NAME $TMPDIR2

run rm -rf $TMPDIR2
