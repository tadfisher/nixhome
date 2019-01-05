{ config, lib, pkgs, ... }:

with lib;

{
  options.profiles.games.enable = mkEnableOption "games";

  config = mkIf config.profiles.games.enable {
    home.packages = with pkgs; [
      gnome3.gnome-chess
      enyo-doom
      gzdoom
      steam
      steam-run
      stockfish
      # vkquake
      winetricks
      wineWowPackages.staging
      yquake2-all-games
    ];
  };
}