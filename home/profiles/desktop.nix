{ config, lib, pkgs, ... }:

with lib;

{
  options.profiles.desktop.enable = lib.mkEnableOption "desktop programs";

  config = mkIf config.profiles.desktop.enable {
    fonts.fontconfig.enable = true;

    gtk.enable = true;

    home.keyboard.options = [ "ctrl:nocaps" "compose:prsc" ];

    home.file = {
      ".Xcompose".text = ''
        include "${pkgs.dotxcompose}/share/dotXCompose"
        include "${pkgs.dotxcompose}/share/emoji.compose"
        include "${pkgs.dotxcompose}/share/modletters.compose"
        include "${pkgs.dotxcompose}/share/tags.compose"
        include "${pkgs.dotxcompose}/share/maths.compose"
      '';

      ".xprofile".text = ''
        . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
        if [[ -e "$HOME/.profile" ]]; then
          . "$HOME/.profile"
        fi
      '';
    };

    home.packages = with pkgs; [
      gksu
      gparted
      keybase
      xorg.xhost

      emacs-all-the-icons-fonts
      jetbrains-mono
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
      chromium.enable = true;
      firefox.enable = true;
    };

    services = {
      # emacs = {
      #   enable = true;
      #   defaultEditor = true;
      # };
    };
  };
}
