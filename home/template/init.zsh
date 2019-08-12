#!/usr/env/bin zsh

BUNDLE="${0:a:h}"

prepend_path() {
  local VAR=$1
  local VAL=$2
  if [[ -z "${(P)VAR}" ]]; then
    export $VAR="$VAL"
  else
    export $VAR="$VAL:${(P)VAR}"
  fi
}

prepend_path  PATH        $BUNDLE/usr/bin
# prepend_path  PYTHONPATH  $BUNDLE/usr/lib/python3.7/site-packages
