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
    transmission-remote-gtk
    ubootTools
  ];

  profiles = {
    dev = {
      enable = true;
      android = {
        enable = true;
        sdk = {
          channel = "canary";
          packages = sdk: with sdk; [
            cmdline-tools-latest
            build-tools-29-0-1
            build-tools-29-0-2
            build-tools-29-0-3
            platform-tools
            platforms.android-23
            platforms.android-24
            platforms.android-25
            platforms.android-26
            platforms.android-28
            platforms.android-29
            emulator
            sources.android-23
            sources.android-24
            sources.android-25
            sources.android-26
            sources.android-27
            sources.android-28
            sources.android-29
            system-images.android-23.google-apis.x86
            system-images.android-26.google-apis-playstore.x86
            system-images.android-28.google-apis-playstore.x86
            system-images.android-28.google-apis.x86-64
            system-images.android-28.default.x86
            system-images.android-29.google-apis-playstore.x86
          ];
        };
      };
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
