{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.profiles.gnome;

in {
  options.profiles.gnome = {
    enable = lib.mkEnableOption "gnome desktop";

    extensions = {
      packages = mkOption {
        type = types.listOf types.package;
        default = [];
        description = ''
          List of Gnome extension packages to install and enable.
        '';
      };

      ids = mkOption {
        type = types.listOf types.str;
        default = [];
        example = literalExample ''
          [
            "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com"
            "user-theme@gnome-shell-extensions.gcampax.github.com"
            "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
            "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
          ]
        '';
        description = ''
          List of Gnome extensions to enable by ID.
        '';
      };
    };
  };

  config = mkIf config.profiles.gnome.enable {
    dconf.settings = {
      "org/gnome/desktop/background" = {
        picture-uri = "file://${config.passthru.dataDir}/Abstract.jpg";
        picture-options = "zoom";
      };

      "org/gnome/desktop/input-sources" = {
        xkb-options = [ "ctrl:nocaps" "compose:prsc" ];
      };

      "org/gnome/desktop/interface" = {
        clock-format = "12h";
        cursor-blink = false;
        cursor-size = 16;
        cursor-theme = "Paper";
        document-font-name = "Noto Sans 9.75";
        gtk-im-module = "xim";
        gtk-key-theme = "Emacs";
        monospace-font-name = "Roboto Mono 9.75";
        scaling-factor = 1;
      };

      "org/gnome/desktop/lockdown" = {
        disable-lock-screen = false;
      };

      "org/gnome/desktop/screensaver" = {
        picture-uri = "file://${config.passthru.dataDir}/Seattle%20Museum%20of%20Pop%20Culture.jpg";
        picture-options = "zoom";
      };

      "org/gnome/desktop/wm/keybindings" = {
        activate-window-menu = [ "" ];
        minimize = [ "" ];
	      move-to-corner-ne = [ "" ];
	      move-to-corner-nw = [ "" ];
	      move-to-corner-se = [ "" ];
	      move-to-corner-sw = [ "" ];
	      move-to-side-e = [ "" ];
	      move-to-side-n = [ "" ];
	      move-to-side-s = [ "" ];
	      move-to-side-w = [ "" ];
	      move-to-workspace-1 = [ "" ];
	      move-to-workspace-2 = [ "" ];
	      move-to-workspace-3 = [ "" ];
	      move-to-workspace-4 = [ "" ];
	      move-to-workspace-5 = [ "" ];
	      move-to-workspace-6 = [ "" ];
	      move-to-workspace-7 = [ "" ];
	      move-to-workspace-8 = [ "" ];
	      move-to-workspace-9 = [ "" ];
	      move-to-workspace-10 = [ "" ];
	      move-to-workspace-down = [ "" ];
	      move-to-workspace-left = [ "" ];
	      move-to-workspace-right = [ "" ];
	      move-to-workspace-up = [ "" ];
        switch-applications = [ "<Alt>Tab" ];
        switch-applications-backward = [ "<Primary><Alt>Tab" ];
        switch-group = [ "<Alt>Above_Tab" ];
        switch-group-backward = [ "<Primary><Alt>Above_Tab" ];
	      switch-to-workspace-1 = [ "" ];
	      switch-to-workspace-2 = [ "" ];
	      switch-to-workspace-3 = [ "" ];
	      switch-to-workspace-4 = [ "" ];
	      switch-to-workspace-5 = [ "" ];
	      switch-to-workspace-6 = [ "" ];
	      switch-to-workspace-7 = [ "" ];
	      switch-to-workspace-8 = [ "" ];
	      switch-to-workspace-9 = [ "" ];
	      switch-to-workspace-10 = [ "" ];
	      switch-to-workspace-down = [ "" ];
	      switch-to-workspace-left = [ "" ];
	      switch-to-workspace-right = [ "" ];
	      switch-to-workspace-up = [ "" ];
      };

      "org/gnome/desktop/wm/preferences" = {
        resize-with-right-button = true;
      };

      "org/gnome/mutter" = {
        auto-maximize = false;
      };

      "org/gnome/mutter/keybindings" = {
        switch-monitor = [];
        toggle-tiled-left = [];
        toggle-tiled-right = [];
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        screensaver = [ "<Primary><Alt>BackSpace" ];
      };

      "org/gnome/settings-daemon/peripherals/mouse" = {
        locate-pointer = true;
      };

      "org/gnome/shell" = {
        enabled-extensions = cfg.extensions.ids
          ++ map (p: p.uuid) cfg.extensions.packages;
      };

      "org/gnome/shell/overrides" = {
        attach-modal-dialogs = false;
        edge-tiling = false;
        workspaces-only-on-primary = false;
      };

      "org/gnome/shell/extensions/paperwm" = {
        horizontal-margin = 0;
        use-default-background = true;
        vertical-margin = 0;
        vertical-margin-bottom = 0;
        window-gap = 0;
      };

      "org/gnome/shell/extensions/paperwm/keybindings" = {
        close-window = [ "<Super>BackSpace" ];
        move-down = [ "<Shift><Super>k" ];
        move-down-workspace = [ "<Shift><Super>n" ];
        move-left = [ "<Shift><Super>j" ];
        move-monitor-left = [ "<Shift><Super>h" ];
        move-monitor-right = [ "<Super>colon" ];
        move-previous-workspace = [ "<Shift><Super>Above_Tab" ];
        move-previous-workspace-backward = [ "<Primary><Shift><Super>Above_Tab" ];
        move-right = [ "<Shift><Super>l" ];
        move-up = [ "<Shift><Super>i" ];
        move-up-workspace = [ "<Shift><Super>p" ];
        new-window = [ "<Super>Return" ];
        previous-workspace = [ "<Super>Above_Tab" ];
        previous-workspace-backward = [ "<Primary><Super>Above_Tab" ];
        slurp-in = [ "<Super>u" ];
        switch-down = [ "<Super>k" ];
        switch-down-workspace = [ "<Super>n" ];
        switch-first = [ "<Primary><Super>j" ];
        switch-last = [ "<Primary><Super>k" ];
        switch-left = [ "<Super>j" ];
        switch-monitor-left = [ "<Super>h" ];
        switch-monitor-right = [ "<Super>semicolon" ];
        switch-right = [ "<Super>l" ];
        switch-up = [ "<Super>i" ];
        switch-up-workspace = [ "<Super>p" ];
        toggle-scratch = [ "<Shift><Super>s" ];
        toggle-scratch-layer = [ "<Super>s" ];
      };

      "org/gnome/shell/extensions/user-theme" = {
        name = "Plata-Noir";
      };

      "org/gnome/shell/keybindings" = {
        focus-active-notification = [ "" ];
        toggle-overview = [ "" ];
      };
    };

    profiles.gnome.extensions = {
      packages = with pkgs; [
        # dash-to-panel
        # freon
        # gsconnect
        # workspace-indicator
        gnomeExtensionsCustom.dash-to-panel
        gnomeExtensions.paperwm
        (gnome3.gnome-shell-extensions.overrideAttrs (attrs: attrs // { uuid = "user-theme@gnome-shell-extensions.gcampax.github.com"; }))
      ];
    };

    home.packages = with pkgs; [
      chrome-gnome-shell
      gnome3.dconf-editor
      gnome3.gnome-boxes
      gnome3.gnome-tweaks
      plata-theme
      paper-icon-theme
      roboto
      virtmanager
    ] ++ cfg.extensions.packages;

    # Prevent clobbering SSH_AUTH_SOCK
    pam.sessionVariables = {
      GSM_SKIP_SSH_AGENT_WORKAROUND = "1";
    };

    programs.chromium.extensions = [
      "gphhapmejobijbbhgpjhcjognlahblep" # GNOME Shell integration
      # "jfnifeihccihocjbfcfhicmmgpjicaec" # GSConnect
    ];

    programs.gnome-terminal.enable = true;

    qt = {
      enable = true;
      platformTheme = "gnome";
    };

    services.gpg-agent.extraConfig = ''
      pinentry-program ${pkgs.pinentry_gnome}/bin/pinentry-gnome3
    '';

    # Disable gnome-keyring ssh-agent
    xdg.configFile = {
      "autostart/gnome-keyring-ssh.desktop".text = ''
        ${lib.fileContents "${pkgs.gnome3.gnome-keyring}/etc/xdg/autostart/gnome-keyring-ssh.desktop"}
        Hidden=true
      '';

      "chromium/native-messaging-hosts/org.gnome.chrome_gnome_shell.json".source =
        "${pkgs.chrome-gnome-shell}/etc/chromium/native-messaging-hosts/org.gnome.chrome_gnome_shell.json";

      # "chromium/native-messaging-hosts/org.gnome.shell.extensions.gsconnect.json".source =
      #   "${pkgs.gnomeExtensions.gsconnect}/etc/chromium/native-messaging-hosts/org.gnome.shell.extensions.gsconnect.json";
    };
  };
}
