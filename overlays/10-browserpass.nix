# TODO Remove when https://github.com/NixOS/nixpkgs/commit/1dc70f969b9c022f5ce3fa2e7b742ed79f2fa39f
# is in the system channel.

let
  pkgsMaster = import (builtins.fetchTarball { url = https://github.com/NixOS/nixpkgs/archive/master.tar.gz; }) {
    overlays = [];
  };

in self: super: {
  browserpass = pkgsMaster.browserpass;
}
