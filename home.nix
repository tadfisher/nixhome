{ pkgs, ... }:

{
  home.packages = with pkgs; [
    adapta-gtk-theme
    i3status
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    roboto
    roboto-mono
  ];

  home.sessionVariables = {
    XKB_DEFAULT_OPTIONS = "ctrl:nocaps";
  };

  gtk = {
    enable = true;
    fontName = "Roboto 9.75";
    themeName = "Adapta-Nokto-Eta";
    gtk2.extraConfig = ''
      gtk-key-theme-name = "Emacs"
    '';
    gtk3.extraConfig = {
      gtk-key-theme-name = "Emacs";
    };
  };

  programs.bash.enable = true;

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "Tad Fisher";
    userEmail = "tadfisher@gmail.com";
    ignores = ["*~" "#*#"];
  };

  programs.home-manager = {
    enable = true;
    path = https://github.com/rycee/home-manager/archive/master.tar.gz;
  };
}
