#!/usr/bin/env sh

set -ex

CONTENT_ROOT="/home/content"
SCRIPTS_ROOT="/home/scripts"

# Replace all values in Valve template files for the actual project
APP_BUILD_FILENAME="$SCRIPTS_ROOT/app_build.vdf"
# Change this according the platform
DEPOT_BUILD_FILENAME="$SCRIPTS_ROOT/depot_build.vdf"

# Escape build description
BUILD_DESCRIPTION=$(printf '%s\n' "$STEAM_DESCRIPTION" | sed -e 's/[\/&]/\\&/g')

# App build file
sed -i 's/{APP_ID}/$STEAM_APP_ID/g' $APP_BUILD_FILENAME
sed -i 's/{DESCRIPTION}/$BUILD_DESCRIPTION/g' $APP_BUILD_FILENAME
sed -i 's/{BRANCH}/$STEAM_BRANCH/g' $APP_BUILD_FILENAME
sed -i 's/{PREVIEW}/$STEAM_PREVIEW/g' $APP_BUILD_FILENAME
sed -i 's/{DEPOT_ID}/$STEAM_DEPOT_ID/g' $APP_BUILD_FILENAME

# Depot build file
sed -i 's/{DEPOT_ID}/$STEAM_DEPOT_ID/g' $DEPOT_BUILD_FILENAME
sed -i 's/{CONTENT_ROOT}/$CONTENT_ROOT/g' $DEPOT_BUILD_FILENAME

# Move project build in the appropriate folder
cp -a "$BUILD_FOLDER/." $CONTENT_ROOT/