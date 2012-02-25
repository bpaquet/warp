#!/bin/sh

SYNTAX="Syntax : $0 ruby_version_from_rbenv"

DIRNAME=`dirname $0`
RELATIVE_WARP_HOME=../../
. $DIRNAME/$RELATIVE_WARP_HOME/common/shell_lib.sh

load_lib ruby

check_export_directory

if [ "$1" = "-install_rbenv" ]; then
  INSTALL_RBENV=1
  shift
fi

RUBY_VERSION=$1
check_not_empty $RUBY_VERSION

shift

SYS_DEPENDENCIES=$*

FROM="$RBENV_DIR/versions/$RUBY_VERSION"
check_directory_exists $FROM

TARGET_NAME=$(generate_ruby_version $RUBY_VERSION)

if [ "$INSTALL_RBENV" = "1" ]; then
  TARGET_NAME="${TARGET_NAME}_rbenv"
fi

TARGET_NAME="${TARGET_NAME}.warp"

check_not_existent $WARP_EXPORT_DIR/$TARGET_NAME

echo "Package ruby version from rbenv : $RUBY_VERSION"
echo "Using system dependencies : $SYS_DEPENDENCIES"
echo "Installing rbenv : $INSTALL_RBENV"

TMPDIR=$(tmpdir)

run cp -r $FROM $TMPDIR

FROM=$TMPDIR/$RUBY_VERSION

echo 'puts $LOAD_PATH.join(":")' | $FROM/bin/ruby > $FROM/bin/.rubylib.orig
check_result

if [ -d $FROM/gemsets ]; then
  if [ "$PACKAGE_GEMSETS" != "1" ]; then
    echo "************************************"
    echo "You have gemsets installed in this ruby. This package will not contains this gemsets."
    echo "If you want to include this gemsets into the package, please set env variable to PACKAGE_GEMSETS=1"
    echo "************************************"
    run rm -rf $FROM/gemsets
  fi
fi

run cp -r $WARP_HOME/common $TMPDIR

echo "#!/bin/sh -e" > $TMPDIR/install
echo "" >> $TMPDIR/install
echo "common/check_dependencies.sh $SYS_DEPENDENCIES" >> $TMPDIR/install

if [ "$INSTALL_RBENV" = "1" ]; then
  echo "common/ruby/setup_rbenv.sh" >> $TMPDIR/install
fi

cat >> $TMPDIR/install <<STOP_SUBSCRIPT

echo "Extracting ruby $RUBY_VERSION to \${HOME}/.rbenv/versions/$RUBY_VERSION"
mkdir -p \${HOME}/.rbenv/versions/$RUBY_VERSION
rm -rf \${HOME}/.rbenv/versions/$RUBY_VERSION
mv $RUBY_VERSION \${HOME}/.rbenv/versions/$RUBY_VERSION

echo "New ruby version $RUBY_VERSION installed"

\${HOME}/.rbenv/bin/rbenv rehash || true
common/ruby/adjust_shebangs.sh \${HOME}/.rbenv/versions/$RUBY_VERSION
common/ruby/adjust_rubylib.sh \${HOME}/.rbenv/versions/$RUBY_VERSION
common/ruby/set_global_ruby_version.sh

echo "Done."

STOP_SUBSCRIPT

run chmod +x $TMPDIR/install

cd $WARP_EXPORT_DIR
check_result

run $WARP_HOME/warper/warp_builder.sh $TARGET_NAME $TMPDIR

rm -rf $TMPDIR