#!/usr/bin/env bash
function validate_env() {
    echo "::debug::Validating \$ENV=${ENV}"
    if [[ -z "${ENV:-}" ]]
    then
        echo "::error title={"ENV"}::\$ENV is not set. Exiting."
        exit 1
    fi

    if [[ "$ENV" != "dev" && "$ENV" != "prod" ]]
    then
        echo "::error title={"ENV"}::\$ENV is not set to dev, test, or production. Exiting."
        exit 1
    fi
}

validate_env # be sure that env is correctly set as other functions depend on it

readonly repository="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd)"

function required_command() {
    if ! command -v $1 &> /dev/null
    then
        echo "$1 could not be found"
        exit
    fi
}

function check_uv() {
    if ! uv --version &> /dev/null
    then
        python3 -m pip install uv
    fi
    required_command uv
}