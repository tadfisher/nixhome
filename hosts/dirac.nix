{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    inkscape
  ];

  profiles = {
    dev = {
      enable = true;

      android = {
        enable = true;
        sdk = {
          channel = "canary";
          packages = sdk: with sdk; [
            tools
            build-tools-29-0-1
            platform-tools
            platforms.android-29
            emulator
            system-images.android-23.google_apis.x86
            system-images.android-26.google_apis_playstore.x86
            system-images.android-28.google_apis_playstore.x86
            system-images.android-29.google_apis_playstore.x86
          ];
        };
      };

      go.enable = true;
      jvm.enable = true;
      nix.enable = true;
      rust.enable = true;
    };
    nixos.enable = true;
    work.enable = true;
  };
}
