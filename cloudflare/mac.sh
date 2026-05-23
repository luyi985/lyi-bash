#!/bin/bash
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

source "$script_dir/settings.sh"

activateCloudclared() {
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