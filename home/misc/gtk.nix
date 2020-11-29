{ config, lib, pkgs, ... }:

with lib;

mkIf (config.gtk.enable) {
  gtk = {
     font = {
      name = "Roboto 9.75";
      package = pkgs.roboto;
    };
    iconTheme = {
      name = "Paper";
      package = pkgs.paper-icon-theme;
    };
    theme = {
      name = "Plata-Noir";
      package = pkgs.plata-theme;
    };
    gtk2.extraConfig = ''
      gtk-cursor-blink = 0
      gtk-im-module = "xim"
      gtk-key-theme-name = "Emacs"
    '';
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-cursor-blink = false;
      gtk-im-module = "xim";
      gtk-key-theme-name = "Emacs";
    };
  };

  home.packages = [
    # paper-icon-theme doesn’t propagate these: https://github.com/NixOS/nixpkgs/issues/84983
    pkgs.gnome3.adwaita-icon-theme
    pkgs.gnome3.gnome-themes-extra
  ];

  qt = {
    enable = mkDefault true;
    platformTheme = mkDefault "gnome";
  };
}
