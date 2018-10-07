{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.inset;

  mkInsetOption = edge: mkOption {
    type = types.ints.unsigned;
    default = 0;
    description = "Inset for the ${edge} screen edge, in pixels.";
    example = "${edge} = 4;";
  };

in {
  options.services.inset = {
    enable = mkEnableOption "inset service";
    left = mkInsetOption "left";
    right = mkInsetOption "right";
    top = mkInsetOption "top";
    bottom = mkInsetOption "bottom";
  };

  config = mkIf cfg.enable {
    systemd.user.services.inset = {
      Unit = {
        Description = "inset";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.inset}/bin/inset ${toString cfg.left} ${toString cfg.right} ${toString cfg.top} ${toString cfg.bottom}";
        RestartSec = 3;
        Restart = "always";
      };

      Install = {
        WantedBy = [ "hm-graphical-session.target" ];
      };
    };
  };
}
