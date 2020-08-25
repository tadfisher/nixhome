{ config, lib, pkgs, ... }:

{
  imports = [ ../modules/services/gnirehtet.nix ];

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
            build-tools-29-0-3
            build-tools-30-0-2
            emulator
            platform-tools
            platforms.android-29
            platforms.android-30
            skiaparser-1
            sources.android-28
            sources.android-29
            system-images.android-23.google-apis.x86
            system-images.android-24.google-apis.x86
            # system-images.android-26.google-apis-playstore.x86
            system-images.android-27.google-apis-playstore.x86
            system-images.android-29.google-apis-playstore.x86
            tools
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
    # home-manager.path = "<home-manager>";
    home-manager.path = "$HOME/src/home-manager";
    lieer.enable = true;
    ssh.extraConfig = ''
      Host tycho,tycho.lan
        Match user tad
          ForwardAgent yes
        Match user nix-ssh
          IdentitiesOnly yes
          IdentityFile nix-ssh@tycho.lan
    '';
  };

  services = {
    gnirehtet.enable = true;
    lieer.enable = true;
    mopidy.enable = true;
  };

  # services.mopidy = {
  #   enable = true;
  #   extensionPackages = [ pkgs.mopidy-gmusic ];
  #   configuration = ''
  #     [audio]
  #     mixer = none

  #     [gmusic]
  #     bitrate = 320
  #     radio_stations_as_playlists = true
  #     refresh_token = 1//06tBrxx4yIYufCgYIARAAGAYSNwF-L9Irk23FK3hynXZDCZ6qIQ-yfammgstT-tXtHrYNbOHKWQY2C61tYUDKBb_wC2ujNEnE2zc
  #   '';
  # };
}
