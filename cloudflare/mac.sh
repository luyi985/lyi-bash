#!/bin/bash
source $(dirname "$0")/settings.sh

activeCloudflared() {
  if ! pgrep -x "cloudflared" > /dev/null
  then
    echo "cloudflared is not running, starting it..."
    brew install cloudflared&& 
    sudo cloudflared service install $MAC_Connector_ID
  else
    echo "cloudflared is already running."
  fi
}

deactivateCloudflared() {
  if pgrep -x "cloudflared" > /dev/null
  then
    echo "cloudflared is running, stopping it..."
    sudo cloudflared service uninstall $MAC_Connector_ID
  else
    echo "cloudflared is not running."
  fi
}