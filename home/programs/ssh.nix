{ config, lib, pkgs, ... }:

with lib;

mkIf config.programs.ssh.enable {
  programs.ssh = {
    controlMaster = "auto";
    controlPersist = "10m";
  };
}
