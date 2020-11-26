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
# Configuration variables
##
source "./config.sh"

FILE_PREFIX="news"

##
# Prime The Cache And Lock Files
##
support.primeLockFiles "${FILE_PREFIX}"
support.primeCache "${NEWS_ENDPOINT}" "${FILE_PREFIX}"

##
# Load JSON Into Variable
##
JSON_CONTENT=$( support.getJson "${FILE_PREFIX}" )

##
# Render Support functions
##
function getDisplayString {
  INPUT="${1}"
  WITH_SPACES="${INPUT//_/ }"
  NO_QUOTES="${WITH_SPACES//\"/}"

  echo "${NO_QUOTES}"
}

function setColor {
  COLOR="${1}"
  STRING="${2}"

  echo "\${color${COLOR}}${STRING}\$color"
}

function renderTitle {
  WEIGHT="${1}"
  STRING=$( \
    printf "%s" "${2}" \
      | fmt -w $TITLE_WIDTH -g $TITLE_WIDTH \
  )

  echo "\${voffset 25}\${font Ubuntu Mono:style=${WEIGHT}}${STRING}\$font\$offset"
}

function renderSource {
  STRING=$( \
    printf "%s" "${1}" \
      | fmt -w $TITLE_WIDTH -g $TITLE_WIDTH \
  )

  echo "\${voffset 2}\${font Ubuntu Mono:style=bold:size=10}${STRING}\$font\$offset"
}

function renderDescription {
  STRING=$( \
    printf "%s" "${1}" \
      | fmt -w $LINE_WIDTH -g $LINE_WIDTH \
  )

  echo "\${voffset 10}${STRING}\$offset"
}


##
# Pull the data from the JSON response
##
RAW_TITLES=$( \
  printf "%s" "${JSON_CONTENT}" \
    | jq '.articles' \
    | jq '.[].title' \
    | sed 's/\\"//g' \
    | sed 's/ /_/g' \
)

RAW_DESCRIPTIONS=$( \
  printf "%s" "${JSON_CONTENT}" \
    | jq '.articles' \
    | jq '.[].description' \
    | sed 's/\\"//g' \
    | sed 's/ /_/g' \
)

RAW_SOURCES=$( \
  printf "%s" "${JSON_CONTENT}" \
    | jq '.articles' \
    | jq '.[].source.name' \
    | sed 's/\\"//g' \
    | sed 's/ /_/g' \
)

##
# Convert the raw data to arrays
##
TITLES=($RAW_TITLES)
SOURCES=($RAW_SOURCES)
DESCRIPTIONS=($RAW_DESCRIPTIONS)

for i in {0..2}
do
  TITLE="${TITLES[$i]}"
  TITLE=$(getDisplayString "${TITLE}")
  TITLE=$(setColor "3" "${TITLE}")

  renderTitle "normal" "${TITLE}"

  SOURCE="${SOURCES[$i]}"
  SOURCE=$(getDisplayString "${SOURCE}")
  SOURCE=$(setColor "4" "${SOURCE}")

  renderSource "${SOURCE}"

  DESCRIPTION="${DESCRIPTIONS[$i]}"
  DESCRIPTION=$(getDisplayString "${DESCRIPTION}")
  DESCRIPTION=$(setColor "5" "${DESCRIPTION}")
  
  renderDescription "${DESCRIPTION}"
done

support.getLastUpdated "${FILE_PREFIX}"
