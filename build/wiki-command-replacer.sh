#!/usr/bin/env bash

set -eu -o pipefail

cd "$(dirname "$0")/.."

MARKER_START='{{COMMAND-OUTPUT "'
MARKER_END='"}}'

if [[ -z "${CI:-}" ]]; then
  # The `_wiki` directory is created in a previous GitHub Action step.
  # This 'if' block is intended to assist with local development activity.
  rm -rf _wiki/
  cp -r wiki/ _wiki/
fi

grep -lrF "${MARKER_START}" _wiki | while read -r file_to_process; do
  echo "Processing markers in ${file_to_process}"

  while IFS=$'\n' read -r line; do
    if [[ ${line} = ${MARKER_START}*${MARKER_END} ]]; then
      COMMAND="${line##"${MARKER_START}"}"
      COMMAND="${COMMAND%%"${MARKER_END}"}"

      if [[ "${COMMAND}" != "phpcs "* ]] && [[ "${COMMAND}" != "phpcbf "* ]]; then
        echo >&2 "  ERROR: refusing to run arbitrary command: ${COMMAND}"
        exit 1
      fi

      #FIXME refuse to run commands with a semicolon / pipe / ampersand / sub-shell

      echo >&2 "  INFO: running: ${COMMAND}"
      (
        eval "${COMMAND}" </dev/null || true
      )
    else
      echo "${line}"
    fi
  done < "${file_to_process}" > build/temp.md

  mv build/temp.md "${file_to_process}"
done
