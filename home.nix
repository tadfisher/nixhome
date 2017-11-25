{ pkgs, ... }:

{
  home.packages = with pkgs; [
    adapta-gtk-theme
    gnupg
    kbfs
    keybase
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    pass
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

  programs.browserpass = {
    enable = true;
    browsers = [ "chromium" "firefox" ];
  };

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: with epkgs; [
      magit
    ];
  };

  programs.firefox.enable = true;

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "Tad Fisher";
    userEmail = "tadfisher@gmail.com";
    ignores = ["*~" "#*#"];
  };

  programs.sway = {
    enable = true;
    config = {
      font = "Roboto 10";
    };
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 3600;
    enableSshSupport = true;
  };

  services.kbfs = {
    enable = true;
    extraFlags = [ "-label kbfs" "-mount-type normal" ];
  };

  services.udiskie.enable = true;

  programs.home-manager = {
    enable = true;
  };
}
