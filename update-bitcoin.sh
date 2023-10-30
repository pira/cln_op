#!/bin/bash

if [ $# -eq 0 ]; then
	echo "Specify bitcoin version (e.g. 25.0)!"
  exit 1
fi

VERSION=$1

cd
rm -f SHA256SUMS
wget https://bitcoincore.org/bin/bitcoin-core-${VERSION}/bitcoin-${VERSION}-x86_64-linux-gnu.tar.gz
wget https://bitcoincore.org/bin/bitcoin-core-${VERSION}/SHA256SUMS

sha256sum --ignore-missing --check SHA256SUMS
if [ $? -eq 0 ]; then
  tar xzf bitcoin-${VERSION}-x86_64-linux-gnu.tar.gz && \
  cd bitcoin-${VERSION}/bin && \
  bitcoin-cli stop && \
  sudo cp ./* /usr/local/bin/ && \
  start-bitcoin.sh && \
  rm -f bitcoin-${VERSION}-x86_64-linux-gnu.tar.gz

else
  echo "Update has failed!"
fi
