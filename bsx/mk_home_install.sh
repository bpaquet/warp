#!/bin/sh -e

DIRNAME=`dirname $0`
ARCHIVE_NAME=$1
shift
DIRECTORY=$1
shift
PATH_IN_HOME_DIRECTORY=$1
shift
SYS_DEPENDENCIES=$*

echo "Creating self installer in home directory"
echo "Archive name : $ARCHIVE_NAME"
echo "From : $DIRECTORY"
echo "Target path in home directory : $PATH_IN_HOME_DIRECTORY"
echo "System dependencies : $SYS_DEPENDENCIES"

TMPDIR=`mktemp -d /tmp/selfextract.XXXXXX`

mkdir -p $TMPDIR
cp -r $DIRECTORY $TMPDIR/data

cat > $TMPDIR/install <<STOP_SUBSCRIPT
#!/bin/sh -e

SYS_DEPENDENCIES="$SYS_DEPENDENCIES"

TO_BE_INSTALLED=""

for i in \$SYS_DEPENDENCIES; do
  echo "Checking \$i"
  RES=$(dpkg -l | cut -d' ' -f 3 | grep \$i)
  if [ "\$RES" = "" ]; then
    TO_BE_INSTALLED="\$TO_BE_INSTALLED \$i"
  fi
done

if [ "\$TO_BE_INSTALLED" != "" ]; then
  echo "Failed : Please run aptitude install \$TO_BE_INSTALLED"
  exit 1
fi

echo "Moving data to \${HOME}/$PATH_IN_HOME_DIRECTORY"
mkdir -pv \${HOME}/$PATH_IN_HOME_DIRECTORY
rm -rf \${HOME}/$PATH_IN_HOME_DIRECTORY
mv data/ \${HOME}/$PATH_IN_HOME_DIRECTORY/

STOP_SUBSCRIPT

cat $TMPDIR/install
chmod +x $TMPDIR/install

$DIRNAME/bsx_builder.sh $ARCHIVE_NAME $TMPDIR

rm -rf $TMPDIR