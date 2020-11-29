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
    bash-completion
    curl
    dosfstools
    file
    gnupg
    jq
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
    direnv = {
      enable = true;
      enableNixDirenvIntegration = true;
      config = {
        whitelist = {
          prefix = [
            "${config.home.homeDirectory}/proj"
            "${config.home.homeDirectory}/simple"
            "${config.home.homeDirectory}/src"
          ];
        };
      };
    };
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
    pass.enable = true;
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
