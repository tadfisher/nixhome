{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.firefox;

in

mkIf (cfg.enable && config.profiles.gnome.enable) {
  programs.firefox.package = pkgs.firefox-wayland;
}