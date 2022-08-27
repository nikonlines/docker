#!/bin/bash

### Usage: ab [options] [http[s]://]hostname[:port]/path
### Options are:
### -n      requests     Number of requests to perform
### -c      concurrency  Number of multiple requests to make at a time
### -k      Use HTTP KeepAlive feature
### -r      Don't exit on socket receive errors
### -H      attribute    Add Arbitrary header line, eg. 'Accept-Encoding: gzip'
### -X      proxy:port   Proxyserver and port number to use

#NUMBER_REQUEST=1000000          ### Number of requests to perform
#NUMBER_CONCURRENCY=1000         ### Number of multiple requests to make at a time
#USER_AGENT="User-Agent: *"

#TOR_ENTRYNODES=""
#TOR_EXITNODES=""
#TOR_STRICTNODES=1

### Proxyserver and port number to use
PROXY_IP=localhost              ### IP localhost
PROXY_PORT=9050                 ### Port socks5
#CONTROL_PORT=9051

### Site for check external IP
SITE_CHECK_IP="ifconfig.me"

SLEEP_TIME=5                    ### Sleep time default 5 sec

#-----------------------------------
function show_arguments() {
  echo "--- Show input arguments for debug ---"
  echo "Site URL: $SITE_URL"
  echo "Number of requests to perform: $NUMBER_REQUEST"
  echo "Number of multiple requests to make at a time: $NUMBER_CONCURRENCY"
  echo "User-Agent: $USER_AGENT"
  echo "TOR EntryNodes: $TOR_ENTRYNODES"
  echo "TOR ExitNodes: $TOR_EXITNODES"
  echo "TOR StrictNodes: $TOR_STRICTNODES"
  echo "Proxy IP: $PROXY_IP"
  echo "Proxy Port: $PROXY_PORT"

  echo "--------------------------------------"
  echo ""
}

#-----------------------------------
function tor_set_config() {
  echo "--- Set TOR config ---"

  if [ -n "$TOR_ENTRYNODES" ]; then
    echo "Set TOR 'EntryNodes': $TOR_ENTRYNODES StrictNodes $TOR_STRICTNODES"
    echo "EntryNodes $TOR_ENTRYNODES StrictNodes $TOR_STRICTNODES" >> /etc/tor/torrc
  fi

  if [ -n "$TOR_EXITNODES" ]; then
    echo "Set TOR 'ExitNodes': $TOR_EXITNODES StrictNodes $TOR_STRICTNODES"
    echo "ExitNodes $TOR_EXITNODES StrictNodes $TOR_STRICTNODES" >> /etc/tor/torrc
  fi

  ### Used tor from proxy (socks5)
  echo "Set TOR proxy (socks5): ${PROXY_IP}:${PROXY_PORT}"
  echo "SOCKSPort ${PROXY_IP}:${PROXY_PORT}" >> /etc/tor/torrc
  #echo "ControlPort ${CONTROL_PORT}" >> /etc/tor/torrc

  echo "----------------------"
  echo ""
}

#-----------------------------------
function tor_restart() {
  echo "--- Restart tor ---"
  #systemctl restart tor
  service tor restart
  echo ""

  echo -n "Sleep $SLEEP_TIME sec..."
  sleep $SLEEP_TIME
  echo "done."

  echo "-------------------"
  echo ""
}

#-----------------------------------
function get_external_ip() {
  echo "Get external IP from TOR exit nodes..."
  #EXTERNAL_IP=$(torsocks curl $SITE_CHECK_IP)
  EXTERNAL_IP=$(curl --socks5 ${PROXY_IP}:${PROXY_PORT} $SITE_CHECK_IP)
  echo "External IP: $EXTERNAL_IP"
  echo ""
}

#-----------------------------------
function run_benchmark() {

  ### Check input site URL
  if [ -z "$SITE_URL" ]; then
    echo "Error: Site for benchmark not set!"
    exit 0
  fi

  for ((;;)); do
    get_external_ip
    #
    echo "--- Start benchmark ---"
    #torsocks ab -n $NUMBER_REQUEST -c $NUMBER_CONCURRENCY -k -r -H "${USER_AGENT}" $SITE_URL
    ab -n $NUMBER_REQUEST -c $NUMBER_CONCURRENCY -k -r -H "${USER_AGENT}" -X ${PROXY_IP}:${PROXY_PORT} $SITE_URL
    echo "--- Stop benchmark ---"
    echo ""
    #
    tor_restart
  done
}

### Get the options
while getopts "p:i:o:r:c:a:s:" OPTIONS; do
  case "$OPTIONS" in
    p) ### Control port for TOR
      CONTROL_PORT=$OPTARG
    ;;
    i) ### Input/entry nodes
      TOR_ENTRYNODES=$OPTARG
    ;;
    o) ### Output/exit nodes
      TOR_EXITNODES=$OPTARG
    ;;
    r) ### Number of requests to perform
      NUMBER_REQUEST=$OPTARG
    ;;
    c) ### Number of multiple requests to make at a time
      NUMBER_CONCURRENCY=$OPTARG
    ;;
    a) ### Set user agent
      USER_AGENT=$OPTARG
    ;;
    s) ### Site URL
      SITE_URL=$OPTARG
    ;;
    *) ### Invalid option
      echo "Error: Invalid option"
      exit
    ;;
  esac
done

#------------------------------
show_arguments
#
tor_set_config
tor_restart
#
run_benchmark
#------------------------------
