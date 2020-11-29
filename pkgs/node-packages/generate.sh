#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nodePackages.node2nix
set -eu -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd ${DIR}
rm -f ./node-env.nix
node2nix -i node-packages.json -o node-packages.nix -c composition.nix
