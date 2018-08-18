{ config, lib, pkgs, ... }:

with lib;

mkIf config.programs.emacs.enable {
  home.packages = with pkgs; [
    ditaa
    graphviz
    (hunspellWithDicts [ hunspellDicts.en-us])
    jre
    plantuml
    silver-searcher
  ];

  programs.emacs = {
    package = if (config.profiles.desktop.enable) then pkgs.emacs else pkgs.emacs25-nox;
  };
}
