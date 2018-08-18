{ config, lib, pkgs, ... }:

with lib;

mkIf config.services.gpg-agent.enable {
  services.gpg-agent = {
    defaultCacheTtl = 3600;
    defaultCacheTtlSsh = 3600;
    enableExtraSocket = true;
    enableSshSupport = true;
    grabKeyboardAndMouse = false;
  };
}
