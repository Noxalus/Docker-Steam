#!/usr/bin/env bash

set -e

CONTENT_ROOT="/home/content"
STEAM_CMD_STDERR_FILE="/root/Steam/logs/stderr.txt"

if [ ! $STEAM_ACCOUNT ]
then
    echo "STEAM_ACCOUNT env variable not found."
    exit 1
fi

if [ ! $STEAM_PASSWORD ]
then
    echo "STEAM_PASSWORD env variable not found."
    exit 1
fi

if [ ! $STEAM_SSFN_FILE_PATH ]
then
    echo "STEAM_SSFN_FILE_PATH env variable not found."
    echo "It's needed to bypass the Steam's two-factor authentication."
    exit 1
fi

set -x

# Use SSFN file to disable 2AF
cp "$STEAM_SSFN_FILE_PATH" /root/Steam

set +x

# Wrap binary using Steam DRM?
if [ $STEAM_DRM_TOOL ]
then
    if [ ! $BINARY_PATH ]
    then
        echo "BINARY_PATH env variable not found."
        exit 1
    fi

    DRM_FLAGS=$([ $STEAM_DRM_FLAGS ] && echo $STEAM_DRM_FLAGS || echo "0")

    set -x

    ABSOLUTE_BINARY_PATH="${CONTENT_ROOT}/${BINARY_PATH}"

    # Request binary with DRM
    /home/steamcmd.sh \
        +login $STEAM_ACCOUNT $STEAM_PASSWORD \
        +drm_wrap $STEAM_APP_ID "$ABSOLUTE_BINARY_PATH" "$ABSOLUTE_BINARY_PATH" $STEAM_DRM_TOOL $STEAM_DRM_FLAGS \
        +quit
fi

# Upload the build
/home/steamcmd.sh \
    +login $STEAM_ACCOUNT $STEAM_PASSWORD \
    +run_app_build_http ./scripts/app_build.vdf \
    +quit

set +x

# Check there is no error
if [ -f $STEAM_CMD_STDERR_FILE ]; then
    cat $STEAM_CMD_STDERR_FILE
    exit 1
fi