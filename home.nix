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

  systemd.user.services.kbfs = let
    cfg = {
      mountPoint = "%h/keybase";
      extraFlags = [ "-label kbfs" "-mount-type normal" ];
    };
  in {
    Unit = {
      Description = "Keybase File System";
      Requires = [ "keybase.service" ];
      After = [ "keybase.service" ];
    };

    Service = {
      Environment = "PATH=/run/wrappers";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${cfg.mountPoint}";
      ExecStart = "${pkgs.kbfs}/bin/kbfsfuse ${toString cfg.extraFlags} ${cfg.mountPoint}";
      ExecStopPost = "/run/wrappers/bin/fusermount -u ${cfg.mountPoint}";
      Restart = "on-failure";
      PrivateTmp = true;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  systemd.user.services.keybase = {
    Unit = {
      Description = "Keybase service";
    };
    
    Service = {
      ExecStart = "${pkgs.keybase}/bin/keybase service --auto-forked";
      Restart = "on-failure";
      PrivateTmp = true;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  programs.home-manager = {
    enable = true;
  };
}
