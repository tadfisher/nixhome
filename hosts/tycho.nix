{ config, lib, pkgs, ... }:

{
  xdg.configFile."autostart/gnome-keyring-ssh.desktop".text = ''
    [Desktop Entry]
    Hidden=true
  '';
}
