{ config, lib, pkgs, ... }:

{

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "transmission-daemon@patapon.info"
      ];
    };
  };

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

    gnome.extensions.packages = [ pkgs.gnomeExtensions.transmission-daemon ];

    nixos.enable = true;
  };


  programs.home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;
}
