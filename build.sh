#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail

readonly ENV="prod"
source "$( dirname "${BASH_SOURCE[0]}" )/scripts/common.sh"

function main {
  required_command python3

  echo ::group::Build the application
  check_uv
  mkdir -p $repository/output
  uv run --with jupyter jupyter nbconvert --execute --embed-images --output $repository/output/index.html --to html $repository/telepass.ipynb
  echo ::endgroup::
}

main "$@"