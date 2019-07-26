{ config, lib, pkgs, ... }:

with lib;

mkIf config.programs.git.enable {
  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    userName = "Tad Fisher";
    userEmail = "tadfisher@gmail.com";
    ignores = [ "*~" "#*#" ];
    signing.key = "tadfisher@gmail.com";
    extraConfig = {
      github.user = "tadfisher";
      branch = {
        autoSetupMerge = "true";
        autoSetupRebase = "remote";
      };
    };
  };
}
