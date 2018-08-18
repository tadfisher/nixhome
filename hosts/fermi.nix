{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    inset
    xorg.xbacklight
  ];

  services.compton = {
    enable = true;
    vSync = "opengl-mswc";
  };

  services.redshift = {
    enable = true;
    latitude = "45.5231";
    longitude = "-122.6765";
  };

  services.udiskie.enable = true;

  systemd.user.services.inset =
    let
      left = 6;
      right = 3;
      top = 5;
      bottom = 0;
    in {
      Unit = {
        Description = "inset";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.inset}/bin/inset ${toString left} ${toString right} ${toString top} ${toString bottom}";
        RestartSec = 3;
        Restart = "always";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

  systemd.user.services.polkit-gnome = {
    Unit = {
      Description = "PolicyKit Authentication Agent";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  xsession = {
    enable = true;
    pointerCursor = {
      package = pkgs.paper-icon-theme;
      name = "Paper";
      size = 16;
    };
    initExtra = ''
      ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr
      export VISUAL="${pkgs.emacs}/bin/emacsclient"
      export EDITOR="$VISUAL"
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
    windowManager.command = ''
      ${pkgs.emacs}/bin/emacs
    '';
  };

  # systemd.user.services.steam-controller =
  #   let
  #     daemon = "${pkgs.sc-controller}/bin/scc-daemon";
  #     device = "sys-devices-valve-sc-Valve_Software_Steam_Controller.device";
  #   in {
  #     Unit = {
  #       Description = "Steam Controller daemon";
  #       After = [ device ];
  #       BindsTo = [ device ];
  #     };

  #     Service = {
  #       Type = "oneshot";
  #       ExecStart = "${daemon} start";
  #       ExecReload = "${daemon} restart";
  #       ExecStop = "${daemon} stop";
  #       RemainAfterExit = true;
  #     };

  #     Install = {
  #       WantedBy = [ device ];
  #     };
  #   };
}
