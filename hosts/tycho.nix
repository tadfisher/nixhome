{ config, lib, pkgs, ... }:

{
  xdg.configFile."autostart/gnome-keyring-ssh.desktop".text = ''
    [Desktop Entry]
    Hidden=true
  '';

  programs.home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;
}
