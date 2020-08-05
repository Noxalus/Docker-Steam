#!/usr/bin/env sh

set -ex

if [ "$BUILD_TARGET" = "StandaloneWindows64" ]; then
    STEAM_DEPOT_ID=$STEAM_WINDOWS_DEPOT_ID
elif [ "$BUILD_TARGET" = "StandaloneOSX" ]; then
    STEAM_DEPOT_ID=$STEAM_OSX_DEPOT_ID
elif [ "$BUILD_TARGET" = "StandaloneLinux64" ]; then
    STEAM_DEPOT_ID=$STEAM_LINUX_DEPOT_ID
fi

CONTENT_ROOT="/home/content"
SCRIPTS_ROOT="/home/scripts"

# Replace all values in Valve template files for the actual project
APP_BUILD_FILENAME="app_build_$STEAM_APP_ID.vdf"
# Change this according the platform
DEPOT_BUILD_FILENAME="depot_build_$STEAM_WINDOWS_DEPOT_ID.vdf"

mv $SCRIPTS_ROOT/app_build_1000.vdf $SCRIPTS_ROOT/$APP_BUILD_FILENAME
mv $SCRIPTS_ROOT/depot_build_1001.vdf $SCRIPTS_ROOT/$DEPOT_BUILD_FILENAME

# App build file
sed -i "s~1000~$STEAM_APP_ID~g" $SCRIPTS_ROOT/$APP_BUILD_FILENAME
sed -i "s~1001~$STEAM_DEPOT_ID~g" $SCRIPTS_ROOT/$APP_BUILD_FILENAME
sed -i "s~Your build description here~$CI_COMMIT_DESCRIPTION~g" $SCRIPTS_ROOT/$APP_BUILD_FILENAME

# Depot build file
sed -i "s~1001~$STEAM_DEPOT_ID~g" $SCRIPTS_ROOT/$DEPOT_BUILD_FILENAME
sed -i "s~D:\\\MyGame\\\rel\\\master\\\~$CONTENT_ROOT~g" $SCRIPTS_ROOT/$DEPOT_BUILD_FILENAME

# Move project build in the appropriate folder
mv "$BUILD_FOLDER" $CONTENT_ROOT