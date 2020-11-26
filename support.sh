#!/bin/bash

##
# Constructor
##
function support {
  echo "This class contains support functions for other scripts"
}

##
# Generates an epoch and echos it to the console
##
function support.getEpoch {
  local EPOCH=$( date +"%s" )

  echo "${EPOCH}"
}

##
# Generates a timestamp and echos it to the console
##
function support.getTimestamp {
  local TIMESTAMP=$( date +"%b %d, %Y at %r" )

  echo "${TIMESTAMP}"
}

##
# Primes the lock files for the script
##
function support.primeLockFiles {
  local FILE_PREFIX="${1}"

  local EPOCH=$( support.getEpoch )

  local EPOCH_FILE="${FILE_PREFIX}-last-updated-epoch.txt"
  local TIMESTAMP_FILE="${FILE_PREFIX}-last-updated-timestamp.txt"
  local CACHE_FILE="${FILE_PREFIX}-cached.json"

  local CACHE_DELAY=3600

  if [[ -f "${EPOCH_FILE}" ]]; then
    local LAST_UPDATED=$( cat "${EPOCH_FILE}" )
    local TIME_DIFF_SECONDS="$(($EPOCH-$LAST_UPDATED))"

    if (( $TIME_DIFF_SECONDS > $CACHE_DELAY )); then
      rm "${LAST_UPDATED_FILE}"
      rm "${CACHE_FILE}"

      echo "${EPOCH}" > "${EPOCH_FILE}"
      echo "${TIMESTAMP}" > "${TIMESTAMP_FILE}"
    fi
  else
    echo "${EPOCH}" > "${EPOCH_FILE}"
    echo "${TIMESTAMP}" > "${TIMESTAMP_FILE}"
  fi
}

##
# Primes the cache for the endpoint
##
function support.primeCache {
  local ENDPOINT="${1}"
  local FILE_PREFIX="${2}"

  local EPOCH=$( support.getEpoch )
  local TIMESTAMP=$( support.getTimestamp )

  local EPOCH_FILE="${FILE_PREFIX}-last-updated-epoch.txt"
  local TIMESTAMP_FILE="${FILE_PREFIX}-last-updated-timestamp.txt"
  local CACHE_FILE="${FILE_PREFIX}-cached.json"

  echo "${EPOCH}" > "${EPOCH_FILE}"
  echo "${TIMESTAMP}" > "${TIMESTAMP_FILE}"

  if [[ -f "$CACHE_FILE" ]]; then
    return;
  fi

  if [[ -s "$CACHE_FILE" ]]; then
    if grep -q '[^[:space:]]' < "$CACHE_FILE"; then
      return;
    fi
  fi

  local JSON_CONTENT=$( curl "${ENDPOINT}" )

  echo "${JSON_CONTENT}" > "${CACHE_FILE}"
}

##
# Returns the json from the cache file
##
function support.getJson {
  local FILE_PREFIX="${1}"
  local CACHE_FILE="${FILE_PREFIX}-cached.json"
  local JSON_CONTENT=$(cat "${CACHE_FILE}")

  echo "${JSON_CONTENT}"
}

function support.getLastUpdated {
  local FILE_PREFIX="${1}"

  local TIMESTAMP_FILE="${FILE_PREFIX}-last-updated-timestamp.txt"
  local DATE=$( cat ${TIMESTAMP_FILE} )

  echo "\${voffset 15}\${color4}\${font Ubuntu Mono:size=10}Updated: ${DATE}\$font\$color\$offset"
}