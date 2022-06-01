FROM debian:buster-slim as binary

ARG TARGETARCH
ARG UPSTREAM_VERSION
ENV DOWNLOAD_URL https://github.com/prysmaticlabs/prysm/releases/download

RUN DEBIAN_FRONTEND=noninteractive \
    apt update && apt install --assume-yes --no-install-recommends wget ca-certificates && \
    wget -q $DOWNLOAD_URL/$UPSTREAM_VERSION/beacon-chain-$UPSTREAM_VERSION-linux-${TARGETARCH:-amd64} -O /usr/local/bin/beacon-chain && \
    wget -q https://github.com/eth-clients/merge-testnets/raw/main/ropsten-beacon-chain/genesis.ssz -O /tmp/genesis.ssz && \
    wget -q https://raw.githubusercontent.com/eth-clients/merge-testnets/main/ropsten-beacon-chain/config.yaml -O /tmp/config.yaml && \
    chmod +x  /usr/local/bin/beacon-chain

FROM debian:buster-slim

#Copy binaries from build stage
COPY --from=binary /usr/local/bin/beacon-chain /usr/local/bin/beacon-chain
COPY --from=binary /tmp/genesis.ssz /genesis.ssz
COPY --from=binary /tmp/config.yaml /config.yaml
# COPY --from=binary /tmp/boot_enr.txt /boot_enr.txt

RUN apt update && \
    apt install -y ca-certificates file && \
    rm -rf /var/lib/apt/lists/*

ADD ssl /ssl/

ENTRYPOINT [ "sh", "-c", "exec beacon-chain \
    --ropsten \
    --datadir=/data \
    --rpc-host=0.0.0.0 \
    --grpc-gateway-host=0.0.0.0 \
    --monitoring-host=0.0.0.0 \
    --http-web3provider=\"$HTTP_WEB3PROVIDER\" \
    --grpc-gateway-port=3500 \
    --grpc-gateway-corsdomain=\"$CORSDOMAIN\" \
    --genesis-state /genesis.ssz \
    --config-file /config.yaml \
    --chain-config-file /config.yaml \
    --accept-terms-of-use \
    $EXTRA_OPTS" ]