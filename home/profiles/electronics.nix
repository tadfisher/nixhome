{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.profiles.electronics;

in {
  options.profiles.electronics.enable = mkEnableOption "electronics";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      eagle
      horizon-eda
      kicad
      librepcb
      openscad
    ];
  };
}
