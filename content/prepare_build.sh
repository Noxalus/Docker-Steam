#!/usr/bin/env sh

set -ex

CONTENT_ROOT="/home/content"
SCRIPTS_ROOT="/home/scripts"

# Replace all values in Valve template files for the actual project
APP_BUILD_FILENAME="app_build_$STEAM_APP_ID.vdf"
# Change this according the platform
DEPOT_BUILD_FILENAME="depot_build_$STEAM_DEPOT_ID.vdf"

mv $SCRIPTS_ROOT/app_build_1000.vdf $SCRIPTS_ROOT/$APP_BUILD_FILENAME
mv $SCRIPTS_ROOT/depot_build_1001.vdf $SCRIPTS_ROOT/$DEPOT_BUILD_FILENAME

# App build file
sed -i "s~1000~$STEAM_APP_ID~g" $SCRIPTS_ROOT/$APP_BUILD_FILENAME
sed -i "s~1001~$STEAM_DEPOT_ID~g" $SCRIPTS_ROOT/$APP_BUILD_FILENAME
sed -i "s~Your build description here~$STEAM_DESCRIPTION~g" $SCRIPTS_ROOT/$APP_BUILD_FILENAME
sed -i "s~\"setlive\"	\"\"~\"setlive\"	\"$STEAM_BRANCH\"~g" $SCRIPTS_ROOT/$APP_BUILD_FILENAME
sed -i "s~\"preview\" \"0\"~\"preview\" \"$STEAM_PREVIEW\"~g" $SCRIPTS_ROOT/$APP_BUILD_FILENAME

# Depot build file
sed -i "s~1001~$STEAM_DEPOT_ID~g" $SCRIPTS_ROOT/$DEPOT_BUILD_FILENAME
sed -i "s~D:\\\MyGame\\\rel\\\master\\\~$CONTENT_ROOT~g" $SCRIPTS_ROOT/$DEPOT_BUILD_FILENAME

# Move project build in the appropriate folder
cp -a "$BUILD_FOLDER/." $CONTENT_ROOT/