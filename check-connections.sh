#!/bin/bash
function _check_port {
  local port=$1
  local msg=$(printf "Port: %5d" $port)
  shift
  ns_data=$(netstat -na)
  for state in "$@"; do
    server_cnt=$(echo "$ns_data" | grep "$port *[0-9.:]\+ *$state" -c)
    client_cnt=$(echo "$ns_data" | grep ":$port *$state" -c)
    diff=$((client_cnt-server_cnt))
    msg=$msg$(printf ", $state = %4d/%4d/%4d"  $client_cnt $server_cnt $diff)
  done
  echo "$msg"
}

SLEEP=${SLEEP:-3}

while true; do
  for port in 61001 8080; do
    _check_port $port  ESTABLISHED TIME_WAIT
  done

  sleep $SLEEP
done
