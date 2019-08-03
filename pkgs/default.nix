{ pkgs ? import <nixpkgs> {},
  super ? import <nixpkgs> {}
}:

with pkgs;

{
  base16-builder-go = callPackage ./base16-builder-go {};

  emacsPackagesCustom = epkgs: with epkgs; {
    base16-plata-theme = callPackage ./emacs/base16-plata-theme {};
    org-jira = callPackage ./emacs/org-jira.nix {};
  };

  gnomeExtensions = super.gnomeExtensions // {
    freon = callPackage ./gnome/freon.nix {};
    top-panel-workspace-scroll = callPackage ./gnome/top-panel-workspace-scroll.nix {};
    transmission-daemon = callPackage ./gnome/transmission-daemon.nix {};
  };

  # https://github.com/NixOS/nixpkgs/pull/65573
  zoom-us = pkgs.libsForQt59.callPackage ./zoom-us {};
}
