{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    brasero
    inkscape
    OVMF
    pencil
    plex-media-player
    transmission-remote-gtk
    ubootTools
  ];

  profiles = {
    dev = {
      enable = true;
      android.enable = true;
      go.enable = true;
      jvm.enable = true;
      nix.enable = true;
      rust.enable = true;
    };
    electronics.enable = true;
    games.enable = true;
    nixos.enable = true;
  };


  programs.home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;
}
