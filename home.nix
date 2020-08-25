{ config, lib, pkgs, ... }:

let
  sysCfg = config.passthru.systemConfig or null;
  nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {};

in {
  imports = [
    nur.repos.rycee.hmModules.emacs-init
    <nixpkgs/nixos/modules/misc/passthru.nix>
    <nixpkgs/nixos/modules/misc/extra-arguments.nix>
  ] ++ import modules/module-list.nix
    ++ import home/module-list.nix;

  home.packages = with pkgs; [
    dosfstools
    file
    gnupg
    lm_sensors
    ripgrep
    rw
    telnet
    trash-cli
    tree
    unrar
    unzip
  ];

  nixpkgs = {
    config = import ./config.nix;
  };

  passthru = {
    dataDir = ./data;
    secrets = import "${config.home.homeDirectory}/${config.services.kbfs.mountPoint}/private/tad/secrets.nix";
  };

  profiles = {
    desktop.enable = lib.mkDefault (sysCfg.services.xserver.enable or config.xsession.enable);
    gnome.enable = lib.mkDefault (sysCfg.services.xserver.desktopManager.gnome3.enable or false);
  };

  programs = {
    bash = {
      enable = true;
      shellAliases = {
        nixf = "${pkgs.nixFlakes}/bin/nix";
      };
    };
    direnv.enable = true;
    emacs = {
      enable = true;
      init.enable = true;
    };
    firefox.enable = true;
    git.enable = true;
    home-manager.enable = true;
    mercurial = {
      enable = true;
      userName = "Tad Fisher";
      userEmail = "tadfisher@gmail.com";
    };
    pass = {
      enable = true;
      package = pkgs.pass.withExtensions (e: [ e.pass-audit e.pass-otp ]);
    };
    ssh.enable = true;
  };

  services = {
    gpg-agent.enable = true;
    kbfs.enable = true;
  };

  xdg.userDirs = {
    enable = true;
    desktop = "$HOME";
    documents = "$HOME/doc";
    download = "$HOME/download";
    music = "$HOME/media/music";
    pictures = "$HOME/media/image";
    publicShare = "$HOME/public";
    templates = "$HOME/templates";
    videos = "$HOME/media/video";
  };

  systemd.user.startServices = true;
}
