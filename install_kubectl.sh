#! /bin/bash
## Method to install kubectl on Ubuntu
# sudo apt-get update && 
# sudo apt-get install -y apt-transport-https ca-certificates curl &&
# curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - &&
# echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list &&
# sudo apt-get update &&
# sudo apt-get install -y kubectl&&
# kubectl version --client

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectlcurl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl