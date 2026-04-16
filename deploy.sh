#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail

readonly ENV="prod"
source "$( dirname "${BASH_SOURCE[0]}" )/scripts/common.sh"

function main {
  required_command tofu
  required_command python3

  echo ::group::Initialize Terraform using OpenTofu
  pushd "$repository/infra"
  tofu init -input=false
  popd
  echo ::endgroup::

  echo ::group::Deploy the application
  pushd "$repository/infra"
  tofu apply -input=false -auto-approve
  popd
  echo ::endgroup::
}

main "$@"