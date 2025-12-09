#!/bin/bash

if [ $# -eq 0 ]; then
	echo "Specify bitcoin version (e.g. 25.0)!"
  exit 1
fi

VERSION=$1

cd
rm -f SHA256SUMS SHA256SUMS.asc
wget https://bitcoincore.org/bin/bitcoin-core-${VERSION}/bitcoin-${VERSION}-x86_64-linux-gnu.tar.gz
wget https://bitcoincore.org/bin/bitcoin-core-${VERSION}/SHA256SUMS
wget https://bitcoincore.org/bin/bitcoin-core-${VERSION}/SHA256SUMS.asc

# Verify maintainer signatures and then validate the file checksum. Do not skip this step.
gpg --verify SHA256SUMS.asc && sha256sum --ignore-missing --check SHA256SUMS
if [ $? -eq 0 ]; then
  tar xzf bitcoin-${VERSION}-x86_64-linux-gnu.tar.gz && \
  cd bitcoin-${VERSION}/bin && \
  echo "Restarting bitcoin and cln" && \
  lightning-cli stop && \
  sudo service tor stop && \
  sleep 5 && \
  bitcoin-cli stop && \
  sleep 10 && \
  sudo cp ./* /usr/local/bin/ && \
  sudo service tor start && \
  start-bitcoin.sh && \
  sleep 5 && \
  start-ln.sh && \
  cd && \
  rm -f bitcoin-${VERSION}-x86_64-linux-gnu.tar.gz SHA256SUMS SHA256SUMS.asc && \
  echo "Update to bitcoin ${VERSION} successfull!"

else
  echo "Update has failed!"
fi
