#!/usr/bin/env bash

set -e

CONTENT_ROOT="/home/content"
SCRIPTS_ROOT="/home/scripts"

# Replace all values in Valve template files for the actual project
APP_BUILD_FILENAME="$SCRIPTS_ROOT/app_build.vdf"
# Change this according the platform
DEPOT_BUILD_FILENAME="$SCRIPTS_ROOT/depot_build.vdf"

# Check needed variables

if [ ! $STEAM_APP_ID ]
then
    echo "STEAM_APP_ID env variable not found."
    exit 1
fi

if [ ! $STEAM_DEPOT_ID ]
then
    echo "STEAM_DEPOT_ID env variable not found."
    exit 1
fi

if [ ! $BUILD_FOLDER ]
then
    echo "BUILD_FOLDER env variable not found."
    exit 1
fi

set -x

# App build file
sed -i 's|{APP_ID}|'$STEAM_APP_ID'|g' $APP_BUILD_FILENAME
sed -i 's|{DEPOT_ID}|'$STEAM_DEPOT_ID'|g' $APP_BUILD_FILENAME

# Escape build description to avoid sed replacement issue
if [ "$STEAM_DESCRIPTION" ]
then
    BUILD_DESCRIPTION=$(printf '%s\n' "$STEAM_DESCRIPTION" | sed -e 's/[\/&]/\\&/g')
    sed -i 's|{DESCRIPTION}|'"$BUILD_DESCRIPTION"'|g' $APP_BUILD_FILENAME
else
    sed -i 's|{DESCRIPTION}|[NO DESCRIPTION PROVIDED]|g' $APP_BUILD_FILENAME
fi

if [ "$BRANCH" ]
then
    sed -i 's|{BRANCH}|'"$STEAM_BRANCH"'|g' $APP_BUILD_FILENAME
else
    sed -i 's|{BRANCH}||g' $APP_BUILD_FILENAME
fi

if [ $STEAM_PREVIEW ]
then
    sed -i 's|{PREVIEW}|'$STEAM_PREVIEW'|g' $APP_BUILD_FILENAME
else
    sed -i 's|{PREVIEW}|0|g' $APP_BUILD_FILENAME
fi

# Depot build file
sed -i 's|{DEPOT_ID}|'$STEAM_DEPOT_ID'|g' $DEPOT_BUILD_FILENAME
sed -i 's|{CONTENT_ROOT}|'$CONTENT_ROOT'|g' $DEPOT_BUILD_FILENAME

# Move project build in the appropriate folder
cp -a "$BUILD_FOLDER/." $CONTENT_ROOT/

set +x

echo "Ready to upload the build to Steam!"
echo "Launch the run_build.sh script when you are ready."