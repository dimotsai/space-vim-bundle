#!/usr/env/bin bash

BUNDLE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

prepend_path() {
  local VAR=$1
  local VAL=$2
  if [[ -z "${!VAR}" ]]; then
    export $VAR="$VAL"
  else
    export $VAR="$VAL:${!VAR}"
  fi
}

prepend_path  PATH        $BUNDLE/usr/bin
# prepend_path  PYTHONPATH  $BUNDLE/usr/lib/python3.7/site-packages
