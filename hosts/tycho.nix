{ config, lib, pkgs, ... }:

{
  accounts.email.accounts."tadfisher@gmail.com".primary = true;

  home.packages = with pkgs; [
    brasero
    celestia
    inkscape
    OVMF
    pencil
    plex-media-player
    rpmextract
    simpleburn
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

  programs.pass.stores.".local/share/pass/personal".primary = true;
}
