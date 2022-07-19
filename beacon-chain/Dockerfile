FROM debian:buster-slim as binary

ARG TARGETARCH
ARG UPSTREAM_VERSION
ENV DOWNLOAD_URL https://github.com/prysmaticlabs/prysm/releases/download

RUN DEBIAN_FRONTEND=noninteractive \
    apt update && apt install --assume-yes --no-install-recommends wget ca-certificates && \
    wget -q $DOWNLOAD_URL/$UPSTREAM_VERSION/beacon-chain-$UPSTREAM_VERSION-linux-${TARGETARCH:-amd64} -O /usr/local/bin/beacon-chain && \
    wget -q https://github.com/eth-clients/merge-testnets/blob/main/ropsten-beacon-chain/genesis.ssz?raw=true -O /tmp/genesis.ssz && \
    chmod +x  /usr/local/bin/beacon-chain

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin
RUN  chmod +x /usr/local/bin/entrypoint.sh

FROM debian:buster-slim

#Copy binaries from build stage
COPY --from=binary /usr/local/bin/beacon-chain /usr/local/bin/beacon-chain
COPY --from=binary /usr/local/bin/entrypoint.sh /usr/local/bin
COPY --from=binary /tmp/genesis.ssz /genesis.ssz
COPY ssl /ssl/
COPY jwtsecret /jwtsecret

RUN apt update && \
    apt install -y ca-certificates file && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]