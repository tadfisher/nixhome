{ config, lib, ... }:

with lib;

mkIf config.services.kbfs.enable {
  services.keybase.enable = true;

  services.kbfs = {
    extraFlags = [ "-label kbfs" "-mount-type normal" ];
    mountPoint = ".local/keybase";
  };
}
