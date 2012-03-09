#!/bin/sh -e

DIRNAME=`dirname $0`

$DIRNAME/install_node.sh
$DIRNAME/install_npm_modules.sh