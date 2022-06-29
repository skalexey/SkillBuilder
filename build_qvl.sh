#!/usr/bin/sh

qvlPath="dependencies/DataModelBuilder/QVL/"
noLogArg="no-log"

curDir=$PWD
echo "=== Build QVL support script ==="

echo "Current dir: $curDir"

if [ ! -z "$2" ]; then
	cd $2
fi

echo "First argument: ${1,,}" 

buildArg="debug"
if [ "${1,,}" == "release" ]; then
	buildArg="release"
fi

echo "run QVL/build.py ${buildArg} ${noLogArg}"
cd ${qvlPath}
python build.py ${noLogArg} ${buildArg} 


