#!/bin/sh -e

cp Gemfile.lock /tmp/Gemfile.lock
echo "$BUNDLE_OPTIONS" > /tmp/Gemfile.lock

HASH=`md5sum /tmp/Gemfile.lock | awk '{print $1}'`

rm /tmp/Gemfile.lock

echo $HASH