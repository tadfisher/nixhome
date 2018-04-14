{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Programs
    android-studio
    blueman
    ditaa
    emacs
    gimp
    gnupg
    gnumake
    graphviz
    (hunspellWithDicts [hunspellDicts.en-us])
    inkscape
    inset
    jetbrains.idea-community
    llvmPackages.clang
    pass
    silver-searcher
    telnet
    trash-cli
    unzip
    xorg.xbacklight

    # Fonts
    emacs-all-the-icons-fonts
    material-icons
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    roboto
    roboto-mono

    # Go
    go
    dep
    libcec

    # Nix
    go2nix
    nix-index
    nix-prefetch-scripts
    nox

    # Python
    python3

    # Rust
    cargo
    carnix
    rustc
    rustfmt
    rustracer

    # Testing
    acpica-tools
    binutils-unwrapped
    dmidecode
    fwts

    # Games
    enyo-doom
    gzdoom
    keen4
    sc-controller
    steam
    steam-run
    vkquake
    yquake2-all-games
  ];

  home.file = {
    ".local/share/fonts/icomoon.ttf".source = ./polybar/icomoon.ttf;
    ".local/share/lib/ditaa.jar".source = "${pkgs.ditaa}/lib/ditaa.jar";
  };

  home.keyboard.options = [ "ctrl:nocaps" ];

  home.sessionVariables = {
    GOPATH = "${config.home.homeDirectory}/go";
    RUST_SRC_PATH = pkgs.rustPlatform.rustcSrc;
  };

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
      gtk-cursor-blink = 0
      gtk-key-theme-name = "Emacs"
    '';
    gtk3.extraConfig = {
      gtk-cursor-blink = false;
      gtk-key-theme-name = "Emacs";
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
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
    signing.key = "tadfisher@gmail.com";
    extraConfig = {
      github.user = "tadfisher";
      pull.rebase = "true";
    };
  };

  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "10m";
  };

  services.compton = {
    enable = true;
    vSync = "opengl-mswc";
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 3600;
    enableSshSupport = true;
    grabKeyboardAndMouse = false;
    # extraConfig = ''
    #   allow-emacs-pinentry
    #   allow-loopback-pinentry
    # '';
  };

  services.kbfs = {
    enable = true;
    extraFlags = [ "-label kbfs" "-mount-type normal" ];
  };

  services.polybar = {
    enable = false;
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

  services.redshift = {
    enable = true;
    latitude = "45.5231";
    longitude = "-122.6765";
  };

  services.udiskie.enable = true;

  services.unclutter.enable = true;

  systemd.user.services.inset =
    let
      left = 6;
      right = 3;
      top = 5;
      bottom = 0;
    in {
      Unit = {
        Description = "inset";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.inset}/bin/inset ${toString left} ${toString right} ${toString top} ${toString bottom}";
        RestartSec = 3;
        Restart = "always";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

  systemd.user.services.steam-controller =
    let
      daemon = "${pkgs.sc-controller}/bin/scc-daemon";
      device = "sys-devices-valve-sc-Valve_Software_Steam_Controller.device";
    in {
      Unit = {
        Description = "Steam Controller daemon";
        After = [ device ];
        BindsTo = [ device ];
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${daemon} start";
        ExecReload = "${daemon} restart";
        ExecStop = "${daemon} stop";
        RemainAfterExit = true;
      };

      Install = {
        WantedBy = [ device ];
      };
    };

  systemd.user.startServices = true;

  xsession = {
    enable = true;
    pointerCursor = {
      package = pkgs.paper-icon-theme;
      name = "Paper";
      size = 16;
    };
    initExtra = ''
      ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr
      export VISUAL="${pkgs.emacs}/bin/emacsclient"
      export EDITOR="$VISUAL"
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
    windowManager.command = ''
      ${pkgs.emacs}/bin/emacs
    '';
  };

  programs.home-manager = {
    enable = true;
  };
}
