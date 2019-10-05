{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.bash;

in

mkIf (cfg.enable) {
  programs.bash = {
    shellAliases = {
      l = "ls -alh --group-directories-first";
      ll = "ls -l --group-directories-first";
    };
  };
}
