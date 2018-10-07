{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    xorg.xbacklight
  ];

  profiles = {
    dev = {
      android.enable = true;
      go.enable = true;
      jvm.enable = true;
      nix.enable = true;
      python.enable = true;
      rust.enable = true;
    };
    exwm.enable = true;
    games.enable = true;
  };

  programs.home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;

  services.inset = {
    enable = true;
    left = 6;
    right = 3;
    top = 5;
    bottom = 0;
  };

  services.redshift = {
    enable = true;
    latitude = "45.5";
    longitude = "-122.7";
  };

  services.steam-controller = {
    enable = true;
    device = "sys-devices-valve-sc-Valve_Software_Steam_Controller.device";
  };

  services.udiskie.enable = true;
}
