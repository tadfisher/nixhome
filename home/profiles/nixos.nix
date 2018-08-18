{ config, lib, ... }:

let
  cfg = config.profiles.nixos;
in {
  imports = [ <nixpkgs/nixos/modules/misc/passthru.nix> ];

  options.profiles.nixos.enable = lib.mkEnableOption "nixos integration";

  config.passthru = if cfg.enable then {
    systemConfig = (import <nixpkgs/nixos> {}).config;
  } else {};
}
