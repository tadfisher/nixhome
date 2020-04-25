{ config, lib, pkgs, ... }:

{
  accounts.email.accounts."tad@simple.com".primary = true;

  home.packages = with pkgs; [
    inkscape
    gimp
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
            system-images.android-28.google-apis.x86
            system-images.android-28.default.x86
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

  programs = {
    home-manager.path = "<home-manager>";
    lieer.enable = true;
  };

  services = {
    lieer.enable = true;
  };

  services.mopidy = {
    enable = true;
    extensionPackages = [ pkgs.mopidy-gmusic ];
    configuration = ''
      [audio]
      mixer = none

      [gmusic]
      bitrate = 320
      radio_stations_as_playlists = true
      refresh_token = 1//06tBrxx4yIYufCgYIARAAGAYSNwF-L9Irk23FK3hynXZDCZ6qIQ-yfammgstT-tXtHrYNbOHKWQY2C61tYUDKBb_wC2ujNEnE2zc
    '';
  };
}
