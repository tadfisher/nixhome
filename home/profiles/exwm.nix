{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.profiles.exwm;

in {
  options.profiles.exwm.enable = mkEnableOption "EXWM profile";

  config = mkIf cfg.enable {
    services.compton = {
      enable = true;
      vSync = "opengl-mswc";
    };

    services.unclutter.enable = true;

    services.gpg-agent.extraConfig = ''
      allow-emacs-pinentry
      allow-loopback-pinentry
      pinentry-program ${pkgs.pinentry_emacs}/bin/pinentry-emacs
    '';

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
  };
}
