{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.steam-controller;

in {
  options.services.steam-controller = {
    enable = mkEnableOption "Steam Controller service";

    device = mkOption {
      type = types.str;
      description = "systemd device unit representing the controller.";
      example = "sys-devices-valve-sc-Valve_Software_Steam_Controller.device";
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.steam-controller =
      let
        daemon = "${pkgs.sc-controller}/bin/scc-daemon";
        device = "sys-devices-valve-sc-Valve_Software_Steam_Controller.device";
      in {
        Unit = {
          Description = "Steam Controller daemon";
          After = [ device ];
          BindsTo = [ device ];
        };

        Service = {
          Type = "oneshot";
          ExecStart = "${daemon} start";
          ExecReload = "${daemon} restart";
          ExecStop = "${daemon} stop";
          RemainAfterExit = true;
        };

        Install = {
          WantedBy = [ device ];
        };
      };
  };
}
