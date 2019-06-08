{ config, lib, pkgs, ... }:

with lib;

{
  options.profiles.gnome.enable = lib.mkEnableOption "gnome desktop";

  config = mkIf config.profiles.gnome.enable {
    dconf.settings = {
      "org/gnome/desktop/background" = {
        picture-uri = "file://${config.passthru.dataDir}/Abstract.jpg";
        picture-options = "zoom";
      };

      "org/gnome/desktop/interface" = {
        cursor-blink = false;
        cursor-size = 16;
        cursor-theme = "Paper";
        document-font-name = "Noto Sans 9.75";
        gtk-key-theme = "Emacs";
        monospace-font-name = "Roboto Mono 9.75";
        scaling-factor = 1;
      };

      "org/gnome/desktop/screensaver" = {
        picture-uri = "file://${config.passthru.dataDir}/Seattle%20Museum%20of%20Pop%20Culture.jpg";
        picture-options = "zoom";
      };

      "org/gnome/desktop/wm/keybindings" = {
        activate-window-menu = [ "" ];
	      move-to-corner-ne = [ "<Super><Control>u" ];
	      move-to-corner-nw = [ "<Super><Control>y" ];
	      move-to-corner-se = [ "<Super><Control>n" ];
	      move-to-corner-sw = [ "<Super><Control>b" ];
	      move-to-side-e = [ "<Super><Control>l" ];
	      move-to-side-n = [ "<Super><Control>k" ];
	      move-to-side-s = [ "<Super><Control>j" ];
	      move-to-side-w = [ "<Super><Control>n" ];
	      move-to-workspace-1 = [ "<Super><Shift>1" ];
	      move-to-workspace-2 = [ "<Super><Shift>2" ];
	      move-to-workspace-3 = [ "<Super><Shift>3" ];
	      move-to-workspace-4 = [ "<Super><Shift>4" ];
	      move-to-workspace-5 = [ "<Super><Shift>5" ];
	      move-to-workspace-6 = [ "<Super><Shift>6" ];
	      move-to-workspace-7 = [ "<Super><Shift>7" ];
	      move-to-workspace-8 = [ "<Super><Shift>8" ];
	      move-to-workspace-9 = [ "<Super><Shift>9" ];
	      move-to-workspace-10 = [ "<Super><Shift>0" ];
	      move-to-workspace-down = [ "<Super><Shift>n" ];
	      move-to-workspace-left = [ "<Super><Shift>b" ];
	      move-to-workspace-right = [ "<Super><Shift>f" ];
	      move-to-workspace-up = [ "<Super><Shift>p" ];
	      switch-to-workspace-1 = [ "<Super>1" ];
	      switch-to-workspace-2 = [ "<Super>2" ];
	      switch-to-workspace-3 = [ "<Super>3" ];
	      switch-to-workspace-4 = [ "<Super>4" ];
	      switch-to-workspace-5 = [ "<Super>5" ];
	      switch-to-workspace-6 = [ "<Super>6" ];
	      switch-to-workspace-7 = [ "<Super>7" ];
	      switch-to-workspace-8 = [ "<Super>8" ];
	      switch-to-workspace-9 = [ "<Super>9" ];
	      switch-to-workspace-10 = [ "<Super>0" ];
	      switch-to-workspace-down = [ "<Super>n" ];
	      switch-to-workspace-left = [ "<Super>b" ];
	      switch-to-workspace-right = [ "<Super>f" ];
	      switch-to-workspace-up = [ "<Super>p" ];
      };

      "org/gnome/desktop/wm/preferences" = {
        resize-with-right-button = true;
      };

      "org/gnome/mutter/keybindings" = {
        toggle-tiled-left = [ "<Shift><Super>h" ];
        toggle-tiled-right = [ "<Shift><Super>l" ];
      };

      "org/gnome/settings-daemon/peripherals/mouse" = {
        locate-pointer = true;
      };

      "org/gnome/shell" = {
        enabled-extensions = [
          "apps-menu@gnome-shell-extensions.gcampax.github.com"
          "caffeine@patapon.info"
          "dash-to-panel@jderose9.github.com"
          "drive-menu@gnome-shell-extensions.gcampax.github.com"
          "freon@UshakovVasilii_Github.yahoo.com"
          "mediaplayer@patapon.info"
          "places-menu@gnome-shell-extensions.gcampax.github.com"
          "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com"
          "scroll-workspaces@gfxmonk.net"
          "transmission-daemon@patapon.info"
          "user-theme@gnome-shell-extensions.gcampax.github.com"
          "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
          "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
        ];
      };

      "org/gnome/shell/extensions/user-theme" = {
        name = "Plata-Noir";
      };

      "org/gnome/shell/keybindings" = {
        focus-active-notification = [ "" ];
      };
    };

    home.packages = with pkgs; [
      gnome3.gnome-boxes
      virtmanager
    ];

    # Prevent clobbering SSH_AUTH_SOCK
    pam.sessionVariables.GSM_SKIP_SSH_AGENT_WORKAROUND = "1";

    services.gpg-agent.extraConfig = ''
      pinentry-program ${pkgs.pinentry_gnome}/bin/pinentry-gnome3
    '';

    # Disable gnome-keyring ssh-agent
    xdg.configFile."autostart/gnome-keyring-ssh.desktop".text = ''
      ${lib.fileContents "${pkgs.gnome3.gnome-keyring}/etc/xdg/autostart/gnome-keyring-ssh.desktop"}
      Hidden=true
    '';
  };
}
