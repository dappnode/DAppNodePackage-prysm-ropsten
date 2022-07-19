#!/bin/bash

if [[ -n $WEB3_BACKUP ]] && [[ $EXTRA_OPTS != *"--fallback-web3provider"* ]]; then
  EXTRA_OPTS="--fallback-web3provider=${WEB3_BACKUP} ${EXTRA_OPTS}"
fi

exec -c beacon-chain \
  --ropsten \
  --datadir=/data \
  --rpc-host=0.0.0.0 \
  --grpc-gateway-host=0.0.0.0 \
  --grpc-gateway-port=3500 \
  --grpc-gateway-corsdomain=$CORSDOMAIN \
  --p2p-local-ip=0.0.0.0 \
  --http-web3provider=$HTTP_WEB3PROVIDER \
  --p2p-tcp-port=$P2P_TCP_PORT \
  --p2p-udp-port=$P2P_UDP_PORT  \
  --accept-terms-of-use \
  --jwt-secret=/jwtsecret \
  #--terminal-total-difficulty-override=$TTD_OVERRIDE \
  --genesis-state=/genesis.ssz \
  $EXTRA_OPTS