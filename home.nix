{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Programs
    emacs
    gnupg
    pass
    hunspell
    hunspellDicts.en-us

    # Fonts
    emacs-all-the-icons-fonts
    material-icons
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    roboto-mono
  ];

  home.keyboard.options = [ "ctrl:nocaps" ];

  gtk = {
    enable = true;
    font = {
      name = "Roboto 9.75";
      package = pkgs.roboto;
    };
    iconTheme = {
      name = "Paper";
      package = pkgs.paper-icon-theme;
    };
    theme = {
      name = "Adapta-Nokto-Eta";
      package = pkgs.adapta-gtk-theme;
    };
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

  programs.firefox.enable = true;

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "Tad Fisher";
    userEmail = "tadfisher@gmail.com";
    ignores = ["*~" "#*#"];
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

  services.polybar = {
    enable = true;
    config = {
      "bar/status" = {
        width = "100%";
        height = "24";
        background = "#000";
        foreground = "#fff";
        font-0 = "Roboto:size=9;2";
        font-1 = "Material Icons:size=9;2";
        modules-right = "network battery date";
      };

      "module/network" = {
        type = "internal/network";
        interface = "wls1";
        label-connected = "";
        label-disconnected = "";
      };

      "module/battery" = {
        type = "internal/battery";
        full-at = 99;
        battery = "BAT0";
        adapter = "AC";
      };

      "module/date" = {
        type = "internal/date";
        time = "%I:%M %p";
        label = "%time%";
      };
    };
    script = "polybar status &";
  };

  services.udiskie.enable = true;

  xsession = {
    enable = true;
    initExtra = ''
      ${pkgs.wmname}/bin/wmname LG3D
      ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr
      export VISUAL="${pkgs.emacs}/bin/emacsclient"
      export EDITOR="$VISUAL"
    '';
    windowManager.command = ''
      ${pkgs.emacs}/bin/emacs --eval "(exwm-enable)"
    '';
  };

  programs.home-manager = {
    enable = true;
  };
}
