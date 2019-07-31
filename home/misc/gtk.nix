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
      gtk-key-theme-name = "Emacs"
    '';
    gtk3.extraConfig = {
      gtk-cursor-blink = false;
      gtk-key-theme-name = "Emacs";
    };
  };

  qt = {
    enable = mkDefault true;
    platformTheme = mkDefault "gtk";
  };
}
