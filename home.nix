{ config, lib, pkgs, ... }:

let
  sysCfg = config.passthru.systemConfig or null;

in {
  imports = import home/module-list.nix ++ [
    <nixpkgs/nixos/modules/misc/extra-arguments.nix>
    <nixpkgs/nixos/modules/misc/passthru.nix>
  ];

  home.packages = with pkgs; [
    dosfstools
    gnupg
    lm_sensors
    ripgrep
    rw
    telnet
    trash-cli
    tree
    unzip
  ];

  nixpkgs.config = import ./config.nix;

  passthru = {
    dataDir = ./data;
  };

  profiles = {
    desktop.enable = lib.mkDefault (sysCfg.services.xserver.enable or config.xsession.enable);
    gnome.enable = lib.mkDefault (sysCfg.services.xserver.desktopManager.gnome3.enable or false);
  };

  programs = {
    bash.enable = true;
    direnv.enable = true;
    emacs.enable = true;
    emacs.init.enable = true;
    firefox.enable = true;
    git.enable = true;
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

  systemd.user.startServices = true;

  programs.home-manager.enable = true;
}
