#!/usr/bin/env bash
set -o errexit -o pipefail -o noclobber -o nounset

function header() {
    text=$1

    echo
    echo
    echo -e "\x1B[1m${text}\x1B[0m"
    echo
    echo
}

header 'Running linter'
npm run-script lint
set +o errexit
git status | grep "modified:"
result=$?
set -o errexit

if [ "$result" -eq 0 ]; then
    echo '#######################################################################################'
    echo "'npm run lint' changed files. Please review and commit these changes."
    echo "If you do not want to keep these changes then check the original files back out."
    echo '#######################################################################################'
    echo
    echo
    git status
    echo
    echo
    exit 1
fi

header 'Running ''Unit Test'''
# npm test
