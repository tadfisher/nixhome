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
    (pass.withExtensions (e: [ e.pass-otp ]))
    rw
    telnet
    trash-cli
    unzip
  ];

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
  };

  profiles = {
    desktop.enable = lib.mkDefault (sysCfg.services.xserver.enable or config.xsession.enable);
    gnome.enable = lib.mkDefault (sysCfg.services.xserver.desktopManager.gnome3.enable or false);
  };

  programs = {
    bash.enable = true;
    emacs.enable = true;
    git.enable = true;
    ssh.enable = true;
  };

  services = {
    gpg-agent.enable = true;
    kbfs.enable = true;
  };

  systemd.user.startServices = true;

  programs.home-manager.enable = true;
}
