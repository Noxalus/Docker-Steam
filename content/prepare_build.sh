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

# Replace all values in Valve template files for the actual project
APP_BUILD_FILENAME="app_build_$STEAM_APP_ID.vdf"
# Change this according the platform
DEPOT_BUILD_FILENAME="depot_build_$STEAM_WINDOWS_DEPOT_ID.vdf"

mv /home/scripts/app_build_1000.vdf /home/scripts/$APP_BUILD_FILENAME
mv /home/scripts/depot_build_1001.vdf /home/scripts/$DEPOT_BUILD_FILENAME

# App build file
sed -i "s~1000~$STEAM_APP_ID~g" /home/scripts/$APP_BUILD_FILENAME
sed -i "s~1001~$STEAM_DEPOT_ID~g" /home/scripts/$APP_BUILD_FILENAME
sed -i "s~Your build description here~$CI_COMMIT_DESCRIPTION~g" /home/scripts/$APP_BUILD_FILENAME

# Depot build file
sed -i "s~1001~$STEAM_DEPOT_ID~g" /home/scripts/$DEPOT_BUILD_FILENAME
sed -i "s~D:\\\MyGame\\\rel\\\master\\\~$CONTENT_ROOT~g" /home/scripts/$DEPOT_BUILD_FILENAME

# Move project build in the appropriate folder
mv "$CI_BUILDS_DIR/$BUILD_TARGET/$BUILD_NAME" $CONTENT_ROOT