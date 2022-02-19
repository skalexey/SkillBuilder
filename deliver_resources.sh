#!/usr/bin/sh

buildFolder="Build-cmake"
databaseFile="resources/database.json"

curDir=$PWD

echo "Current dir: $curDir"

if [ ! -z "$2" ]; then
	cd $2
fi

buildConfig="Debug"
if [ "${1,,}" == "release" ]; then
	buildConfig="Release"
fi

buildConfigFolder="$buildFolder/$buildConfig/"

echo "Nothing to do for now"

#rm "${buildConfigFolder}database.json"
#echo "Copy '$databaseFile' to the build config folder $buildConfigFolder"
#cp -r "$databaseFile" "$buildConfigFolder"

