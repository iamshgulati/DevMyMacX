#!/bin/sh

# Input variables
CLOUD_APPS_STORE_LOCATION=$1

# Default values
DEFAULT_CLOUD_APPS_STORE_LOCATION=${HOME}/Library/Mobile\ Documents/com\~apple\~CloudDocs/.DevMyMacX/Apps
[ -z "${CLOUD_APPS_STORE_LOCATION}" ] && CLOUD_APPS_STORE_LOCATION=$DEFAULT_CLOUD_APPS_STORE_LOCATION

echo "Installing user's downloaded apps from cloud backup..."
for APP in "${CLOUD_APPS_STORE_LOCATION}"/*.app; do
  [ -d "${APP}" ] && echo "Installing $(basename -- "$APP")..." && cp -rf "${APP}" /Applications/
done