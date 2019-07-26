{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.profiles.work;

  simple-vpn = let
    script = pkgs.writeShellScriptBin "simple-vpn" ''
      set -e
      vpn="simple-vpn-udp"
      nmcli con down "$vpn" &> /dev/null || true
      pass otp show bastion/tad | ${pkgs.networkmanager}/bin/nmcli --ask con up "$vpn" &> /dev/null
    '';
    desktopItem = pkgs.makeDesktopItem {
      name = "simple-vpn";
      exec = "${script}/bin/simple-vpn";
      comment = "Connect to the Simple VPN";
      desktopName = "Simple VPN";
      genericName = "Simple VPN";
      icon = "network-vpn-symbolic.symbolic";
      categories = "System;Network;";
      extraEntries = ''
        Keywords=VPN;
      '';
    };
  in pkgs.buildEnv {
    name = "simple-vpn";
    paths = [ script desktopItem ];
  };

in {
  imports = [ ../programs/firefox.nix ];

  options = {
    profiles.work.enable = mkEnableOption "work profile";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      slack
      simple-vpn
      zoom-us
    ];

    programs.git = {
      includes = [
        { path = "${config.xdg.configHome}/git/config-work"; condition = "gitdir:~/simple/"; }
      ];
    };

    programs.firefox = {
      profiles = {
        work = {
          name = "work";
          path = "work";
          id = 0;
          isDefault = true;
        } // config.programs.firefox.commonProfileConfig;
        personal = {
          name = "personal";
          path = "personal";
          id = 1;
        } // config.programs.firefox.commonProfileConfig;
      };
    };

    xdg.configFile."git/config-work".text = ''
      [user]
      email = tad@simple.com
      signingKey = tad@simple.com
    '';
  };
}
