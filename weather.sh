#!/bin/bash

##
# Make sure the files are colated with the script
##
WORKING_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd "${WORKING_DIR}"

##
# Load Dependencies
##
source "./support.sh"

##
# Configuration Variables
##
source "./config.sh"

FILE_PREFIX="weather"

##
# Prime The Cache And Lock Files
##
support.primeLockFiles "${FILE_PREFIX}"
support.primeCache "${WEATHER_ENDPOINT}" "${FILE_PREFIX}"

##
# Load JSON Into Variable
##
JSON_CONTENT=$( support.getJson "${FILE_PREFIX}" )

MIN_TEMP=$( \
  printf "%s" "${JSON_CONTENT}" \
    | jq '.main' \
    | jq '.temp_min' \
    | awk '{print ($0-int($0)>0)?int($0)+1:int($0)}' \
)

MAX_TEMP=$( \
  printf "%s" "${JSON_CONTENT}" \
    | jq '.main' \
    | jq '.temp_max' \
    | awk '{print ($0-int($0)>0)?int($0)+1:int($0)}' \
)

CURRENT_TEMP=$( \
  printf "%s" "${JSON_CONTENT}" \
    | jq '.main' \
    | jq '.temp' \
    | awk '{print ($0-int($0)>0)?int($0)+1:int($0)}' \
)

echo "\${color3}MIN:\$color ${MIN_TEMP}°" \
"  -  \${color3}CUR:\$color ${MAX_TEMP}°" \
"  -  \${color3}MAX:\$color ${CURRENT_TEMP}°"