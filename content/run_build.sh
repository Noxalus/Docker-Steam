#!/usr/bin/env sh

# Used to disable 2AF
mv $STEAM_SSFN_FILE_PATH /root/Steam

# Upload the build
/home/steamcmd.sh +login $STEAM_ACCOUNT $STEAM_PASSWORD +run_app_build_http ./scripts/app_build_$STEAM_APP_ID.vdf +quit