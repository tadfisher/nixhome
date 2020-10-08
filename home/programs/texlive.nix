{ config, lib, ... }:

with lib;

let
  cfg = config.programs.texlive;

in

mkIf cfg.enable {
  programs.texlive.extraPackages = tpkgs: {
    inherit (tpkgs)
      scheme-medium
      capt-of
      fontawesome
      inconsolata
      moderncv
      upquote
      wrapfig;
  };
}
