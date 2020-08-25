{ config, lib, pkgs, ... }:

with lib;

mkIf config.services.mopidy.enable {
  services.mopidy = {
    extensionPackages = with pkgs; [
      mopidy-mpd
      mopidy-mpris
      mopidy-somafm
      mopidy-youtube-music
    ];

    configuration = ''
      [core]
      restore_state = true

      [audio]
      mixer = none

      [mpd]
      enabled = true
      hostname = 127.0.0.1

      [youtube]
      api_enabled = true
      autoplay_enabled = true
      youtube_api_key = ${config.passthru.secrets.google.apiKey}
    '';
  };
}
