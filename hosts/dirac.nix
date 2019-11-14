{ config, lib, pkgs, ... }:

{
  accounts.email.accounts."tad@simple.com".primary = true;

  home.packages = with pkgs; [
    inkscape
    gimp
    lieer
  ];

  profiles = {
    dev = {
      enable = true;

      android = {
        enable = true;
        pkgs = ~/proj/android-nixpkgs;
        sdk = {
          channel = "canary";
          packages = sdk: with sdk; [
            tools
            build-tools-29-0-1
            build-tools-29-0-2
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
            system-images.android-24.google-apis-playstore.x86
            system-images.android-25.google-apis-playstore.x86
            system-images.android-26.google-apis-playstore.x86
            system-images.android-27.google-apis-playstore.x86
            system-images.android-28.google-apis-playstore.x86
            system-images.android-28.google-apis.x86
            system-images.android-29.google-apis-playstore.x86
          ];
        };
      };

      go.enable = true;
      jvm.enable = true;
      nix.enable = true;
      python.enable = true;
      rust.enable = true;
    };
    nixos.enable = true;
    work.enable = true;
  };
}
