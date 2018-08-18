{ config, lib, pkgs, ... }:

with lib;

{
  options.profiles.desktop.enable = lib.mkEnableOption "desktop programs";

  config = mkIf config.profiles.desktop.enable {
    gtk.enable = true;

    home.keyboard.options = [ "ctrl:nocaps" ];

    home.file.".xprofile".text = ''
      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      if [[ -e "$HOME/.profile" ]]; then
        . "$HOME/.profile"
      fi
    '';

    home.packages = with pkgs; [
      calibre
      chromium
      gksu
      gparted
      keybase
      xorg.xhost

      emacs-all-the-icons-fonts
      material-icons
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      roboto
      roboto-mono
    ];

    programs = {
      browserpass = {
        enable = true;
        browsers = [ "chromium" "firefox" ];
      };

      firefox.enable = true;
    };

    services.unclutter.enable = true;
  };
}
