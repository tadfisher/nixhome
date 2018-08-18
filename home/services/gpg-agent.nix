{ config, lib, pkgs, ... }:

with lib;

mkIf config.services.gpg-agent.enable {
  services.gpg-agent = {
    defaultCacheTtl = 3600;
    enableSshSupport = true;
    grabKeyboardAndMouse = false;
    # extraConfig = ''
    #   allow-emacs-pinentry
    #   allow-loopback-pinentry
    # '';
  };
}
