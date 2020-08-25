{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.slack;

  desktopItem = pkgs.makeDesktopItem {
    name = "slack";
    exec = "${pkgs.slack}/bin/slack ${concatStringsSep " " cfg.arguments} %U";
    icon = "${pkgs.slack}/share/pixmaps/slack.png";
    comment = "Slack Desktop";
    desktopName = "Slack";
    genericName = "Slack Client for Linux";
    mimeType = "x-scheme-handler/slack";
    categories = "GNOME;GTK;Network;InstantMessaging;";
    startupNotify = "true";
    extraEntries = ''
      StartupWMClass=Slack
    '';
  };

in

{
  options.programs.slack = {
    enable = mkEnableOption "Slack messaging client";

    arguments = mkOption {
      type = types.listOf types.str;
      default = [];
      example = literalExample [ "--silent" ];
      description = "Extra command-line arguments to launch Slack with.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.slack ];

    xdg.dataFile."applications/slack.desktop".source = "${desktopItem}/share/applications/slack.desktop";
  };
}
