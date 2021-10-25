#!/bin/bash
set -e
ARCH=$(uname -m)
URL=https://storage.googleapis.com/gvisor/releases/release/latest/${ARCH}

echo "Downloading files"
curl -LJO ${URL}/runsc
curl -LJO ${URL}/runsc.sha512
curl -LJO ${URL}/containerd-shim-runsc-v1
curl -LJO ${URL}/containerd-shim-runsc-v1.sha512
sha512sum -c runsc.sha512 -c containerd-shim-runsc-v1.sha512
rm -f *.sha512
chmod a+rx runsc containerd-shim-runsc-v1

echo "Move files to /usr/local/bin"
sudo mv runsc containerd-shim-runsc-v1 /usr/local/bin