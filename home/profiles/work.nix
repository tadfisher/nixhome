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
  options = {
    profiles.work.enable = mkEnableOption "work profile";
  };

  config = mkIf cfg.enable {

    accounts.email.accounts."tad@simple.com" = {
      address = "tad@simple.com";
      flavor = "gmail.com";
      gpg = {
        key = "tad@simple.com";
        signByDefault = true;
      };
      msmtp.enable = true;
      notmuch.enable = true;
      passwordCommand = "pass show mail.google.com/tad@simple.com | head -n 1";
      realName = "Tad Fisher";
      userName = "tad@simple.com";
    };

    home.packages = with pkgs; [
      slack
      simple-vpn
    ];

    programs.emacs.init.usePackage = {
      org-jira = {
        enable = true;
        package = epkgs: (pkgs.emacsPackagesCustom epkgs).org-jira;
        config = ''
          (setq jiralib-url "https://banksimple.atlassian.net")
        '';
      };
    };

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

    programs.pass.stores = {
      ".local/share/pass/work" = {
        primary = true;
        alias = "pw";
      };
    };

    programs.zoom-us.enable = true;

    xdg.configFile."git/config-work".text = ''
      [user]
      email = tad@simple.com
      signingKey = tad@simple.com
    '';
  };
}
