#! /bin/bash

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    OS="darwin"
    if [[ $(uname -m) == "arm64" ]]; then
        ARCH="arm64"
    else
        ARCH="amd64"
    fi
else
    # Linux
    OS="linux"
    ARCH="amd64"
fi

echo "Downloading kubectl for $OS/$ARCH..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/$OS/$ARCH/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version --client