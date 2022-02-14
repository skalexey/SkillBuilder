#!/usr/bin/sh

curDir=$PWD

echo "Run construct_resources_qrc.sh"
echo "Current dir: $curDir"

if [ ! -z "$1" ]; then
	echo "Work directory passed: $1"
	cd $1
fi

cd resources
rcc --project --output=resources.qrc

cd $curDir