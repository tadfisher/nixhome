{ config, lib, pkgs, ... }:

{
  options.profiles.gnome.enable = lib.mkEnableOption "gnome desktop";

  config = lib.mkIf config.profiles.gnome.enable {
    home.packages = with pkgs; [
      gnome3.gnome-boxes
      virtmanager
    ];

    # Prevent clobbering SSH_AUTH_SOCK
    pam.sessionVariables.GSM_SKIP_SSH_AGENT_WORKAROUND = "1";

    # Disable gnome-keyring ssh-agent
    xdg.configFile."autostart/gnome-keyring-ssh.desktop".text = ''
      ${lib.fileContents "${pkgs.gnome3.gnome-keyring}/etc/xdg/autostart/gnome-keyring-ssh.desktop"}
      Hidden=true
    '';
  };
}
