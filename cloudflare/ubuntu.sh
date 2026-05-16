#!/bin/bash
source $(dirname "$0")/settings.sh

activeCloudflared() {
    # Add cloudflare gpg key
    sudo mkdir -p --mode=0755 /usr/share/keyrings
    curl -fsSL https://pkg.cloudflare.com/cloudflare-public-v2.gpg | sudo tee /usr/share/keyrings/cloudflare-public-v2.gpg >/dev/null

    # Add this repo to your apt repositories
    echo 'deb [signed-by=/usr/share/keyrings/cloudflare-public-v2.gpg] https://pkg.cloudflare.com/cloudflared any main' | sudo tee /etc/apt/sources.list.d/cloudflared.list

    # install cloudflared
    sudo apt-get update && sudo apt-get install cloudflared && sudo cloudflared service install $UBUNTU_Connector_ID
}

deactivateCloudflared() {
  if pgrep -x "cloudflared" > /dev/null
  then
    echo "cloudflared is running, stopping it..."
    sudo cloudflared service uninstall $UBUNTU_Connector_ID
  else
    echo "cloudflared is not running."
  fi
}