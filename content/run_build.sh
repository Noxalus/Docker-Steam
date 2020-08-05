#!/usr/bin/env sh

./steamcmd.sh +login $STEAM_ACCOUNT $STEAM_PASSWORD +run_app_build_http ./scripts/app_build_$STEAM_APP_ID.vdf +quit