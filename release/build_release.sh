#!/bin/bash

BUILD_NUMBER=$1
BUILD_NAME=graylog2-stream-dashboard-$BUILD_NUMBER
BUILD_DIR=builds/$BUILD_NAME
BUILD_DATE=`date`
LOGFILE=`pwd`/logs/$BUILD_NAME

# Check if required version parameter is given
if [ -z $BUILD_NUMBER ]; then
  echo "ERROR: Missing parameter. (build number)"
  exit 1
fi

# Create directories
mkdir -p logs
mkdir -p builds
mkdir -p $BUILD_DIR

# Create logfile
touch $LOGFILE
date >> $LOGFILE

echo "BUILDING $BUILD_NAME"

echo "RUNNING GRUNT"
/usr/local/share/npm/lib/node_modules/grunt-cli/bin/grunt bower-install

# Add build date to release.
echo $BUILD_DATE > $BUILD_DIR/build_date

echo "Copying files ..."

# Copy files.
cp -R ../app ../README.md ../COPYING $BUILD_DIR

cd builds/

# tar it
echo "Building Tarball ..."
gtar cfz $BUILD_NAME.tar.gz $BUILD_NAME
rm -rf ./$BUILD_NAME
mv $BUILD_NAME.tar.gz $BUILD_NAME.tgz

echo "DONE! Created release $BUILD_NAME on $BUILD_DATE"