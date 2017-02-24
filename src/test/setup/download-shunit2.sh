#!/bin/bash

GIT=$(which git)
if [ $? -ne 0 ] ; then
  printf "git must be installed and available on the PATH.\n" 1>&2
  exit 1
fi
TIMESTAMP=$(date "+%Y-%m-%d_%H-%M-%S")
TMP_DIR=/tmp/shunit2_${TIMESTAMP}_$$
SHUNIT2_URL="https://github.com/kward/shunit2.git"
SCRIPT_DIR="$(dirname $0)"
BASE_DIR="${SCRIPT_DIR}/../../../"
LIB_DIR="${SCRIPT_DIR}/../lib"
SHUNIT2_DIR="${LIB_DIR}/shunit2"


if [ -e "$SHUNIT2_DIR" ] ; then
  rm -rf "$SHUNIT2_DIR"
fi

$GIT clone "$SHUNIT2_URL" "$TMP_DIR"

if [ $? -eq 0 ] ; then
  mkdir -p "${LIB_DIR}"
  mv "$TMP_DIR" "${SHUNIT2_DIR}" 
  rm -rf "${SHUNIT2_DIR}/.git"
  if [ -e "$BASE_DIR/.gitignore" ] ; then
    if [ $(grep -c "src/test/lib/shunit2/" "$BASE_DIR/.gitignore") -eq 0 ] ; then
      printf "\nsrc/test/lib/shunit2/\n" >> "$BASE_DIR/.gitignore"
    fi
  else
    printf "src/test/lib/shunit2/\n" > "$BASE_DIR/.gitignore"
    $GIT add "$BASE_DIR/.gitignore"
  fi
  printf "shunit2 download and setup successfully!\n"
else
  printf "Unable to download shunit2 from $SHUNIT2_URL\n" 1>&2
  exit 1
fi
