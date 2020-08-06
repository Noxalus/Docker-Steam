# DockerSteam

Project to build a Docker image with Steamworks API installed to easily deploy a build on Steam.

The image produced is uploaded on Docker Hub [here](https://hub.docker.com/repository/docker/homolus/dockersteam).

It contains `steamcmd` binary and scripts to prepare the build before the upload (change the app id, the branch, etc...).

# How to build

The `.gitlab-ci.yml` file will do the job for you, but you need to define some environment variables in your CI settings:

- `CI_REGISTRY`: Use `docker.io` if you want to publish the image on Docker Hub registry.
- `CI_REGISTRY_IMAGE`: It's the URL to the registry (ex: `index.docker.io/homolus/dockersteam`).
- `CI_REGISTRY_USER`: The user account on the registry (ex: `homolus`).
- `CI_REGISTRY_PASSWORD`: The password of this account.

# How to use the image

First, you will need to define multiple environment variables for your project:
- `BUILD_FOLDER`: The path to your game folder (the one you want to upload).
- `STEAM_ACCOUNT`: The account you want to use to deploy your game build.
- `STEAM_PASSWORD`: The password of this account.
- `STEAM_SSFN_FILE_PATH`: The path to the SSFN file use to get rid of the 2AF (more info [here](https://gitlab.com/homo-ludens/dockersteam/-/wikis/How-to-skip-Steam-2AF)) 
- `STEAM_APP_ID`: Your project App ID on the Steamworks dashboard.
- `STEAM_DEPOT_ID`: The Depot ID where you want to upload your game build (can be found on the Steamworks dashboard).
- `STEAM_DESCRIPTION`: The description you want to specify for your game build.
- `STEAM_BRANCH`: The branch you want this build to be available on.
- `STEAM_PREVIEW`: **"1"** if it's a preview build, else **"0"**

Make sure to retrieve the SSFN file and define the `STEAM_SSFN_FILE_PATH` variable or it won't work. If you don't know what it is, please check [this page](https://gitlab.com/homo-ludens/dockersteam/-/wikis/How-to-skip-Steam-2AF).

When the image is downloaded, you need to call the `prepare_build.sh` script:

`/home/prepare_build.sh`

This will replace all values in `app_build_*.vdf` and `depot_build_*.vdf` files by the ones you specified through environment variables.

Then, call the `run_build.sh` script:

`/home/run_build.sh`