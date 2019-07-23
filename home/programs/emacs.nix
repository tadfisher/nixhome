{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.emacs;

in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ditaa
      graphviz
      (hunspellWithDicts [ hunspellDicts.en-us])
      jre
      plantuml
      silver-searcher
    ];
  
    programs.emacs = {
      package = if (config.profiles.desktop.enable) then pkgs.emacs else pkgs.emacs26-nox;
    };
  };
}
