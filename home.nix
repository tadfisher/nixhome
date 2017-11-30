{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Programs
    emacs
    gnome3.file-roller
    gnome3.nautilus
    gnupg
    (hunspellWithDicts [hunspellDicts.en-us])
    inkscape
    pass
    unzip

    # Fonts
    emacs-all-the-icons-fonts
    material-icons
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    roboto-mono
  ];

  home.file = {
    ".local/share/fonts/icomoon.ttf".source = ./polybar/icomoon.ttf;
  };

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
      settings = {
        format-offset = 2;
      };

      colors = {
        active = "#90FFFFFF";
        inactive = "#60FFFFFF";
        foreground = "#FFFFFFFF";
        background = "#4CFFFFFF";
        alert = "#FFD50000";
      };

      "bar/status" = {
        width = "100%";
        height = "24";
        background = "#000";
        foreground = "#fff";
        font-0 = "Roboto Medium:size=8.5;2";
        font-1 = "icomoon:size=11;3";
        padding = 2;
        modules-left = "workspaces";
        modules-right = "network battery date";
        enable-ipc = true;
      };

      "module/workspaces" = {
        type = "internal/xworkspaces";
        label-empty = "";
        label-active = "";
        label-active-foreground = "\${colors.active}";
        label-empty-foreground = "\${colors.background}";
      };

      "module/network" = {
        type = "internal/network";
        interface = "wls1";
        format-connected = "<label-connected>%{O-15}<ramp-signal>%{O-}";
        label-connected = "";
        label-disconnected = "";
        ramp-signal-0 = "";
        ramp-signal-1 = "";
        ramp-signal-2 = "";
        ramp-signal-3 = "";
        label-connected-foreground = "\${colors.background}";
        ramp-signal-foreground = "\${colors.foreground}";
      };

      "module/battery" = {
        type = "internal/battery";
        battery = "BAT0";
        adapter = "AC";
        poll-interval = 5;

        # discharging
        format-discharging = "<label-discharging>%{O-15}<ramp-capacity>%{O-}";
        label-discharging = "";
        ramp-capacity-0 = "";
        ramp-capacity-1 = "";
        ramp-capacity-2 = "";
        ramp-capacity-3 = "";
        ramp-capacity-4 = "";
        ramp-capacity-5 = "";
        ramp-capacity-6 = "";
        ramp-capacity-7 = "";
        label-discharging-foreground = "\${colors.background}";
        ramp-capacity-foreground = "\${colors.foreground}";
        ramp-capacity-0-foreground = "\${colors.alert}";

        # charging
        format-charging = "<label-charging>%{O-15}<animation-charging>%{O-}";
        label-charging = "";
        animation-charging-0 = "";
        animation-charging-1 = "";
        animation-charging-2 = "";
        animation-charging-3 = "";
        animation-charging-4 = "";
        animation-charging-5 = "";
        animation-charging-6 = "";
        label-charging-foreground = "\${colors.background}";
        animation-charging-foreground = "\${colors.foreground}";

        # full
        label-full = "";
        label-full-foreground = "\${colors.foreground}";
      };

      "module/date" = {
        type = "internal/date";
        time = "%OI:%M";
        label = "%time%";
        format-padding = 1;
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
