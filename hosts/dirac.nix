{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    inkscape
  ];

  profiles = {
    dev = {
      enable = true;
      android.enable = true;
      go.enable = true;
      jvm.enable = true;
      nix.enable = true;
      rust.enable = true;
    };
    nixos.enable = true;
  };
}
