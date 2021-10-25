#!/bin/bash
echo "Download Kata Containers release from GitHub"
curl -LJO https://github.com/kata-containers/kata-containers/releases/download/2.2.2/kata-static-2.2.2-x86_64.tar.xz

echo "Unpack the downloaded archive"
xzcat kata-static-2.2.2-x86_64.tar.xz | sudo tar -xvf - -C /

echo "Add symbolic link"
sudo ln -s /opt/kata/bin/kata-runtime /usr/local/bin
sudo ln -s /opt/kata/bin/containerd-shim-kata-v2 /usr/local/bin

echo "Check kata-runtime version"
/opt/kata/bin/kata-runtime --version

echo "Check if kata-runtime is working"
sudo kata-runtime kata-check