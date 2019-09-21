{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.zoom-us;

  zoomWrapped = pkgs.zoom-us.overrideAttrs (attrs: {
    qtWrapperArgs = attrs.qtWrapperArgs ++ [ ''--prefix LD_PRELOAD : ${pkgs.fakeos}/lib/libfakeos.so''];
  });

in

{
  options.programs.zoom-us.enable = mkEnableOption "zoom-us";

  config = mkIf cfg.enable {
    home.packages = [ zoomWrapped ];

    xdg.configFile."fakeos/os-release".text = ''
      NAME="Arch Linux"
      PRETTY_NAME="Arch Linux"
      ID=arch
      ID_LIKE=archlinux
      ANSI_COLOR="0;36"
      HOME_URL="https://www.archlinux.org/"
      SUPPORT_URL="https://bbs.archlinux.org/"
      BUG_REPORT_URL="https://bugs.archlinux.org"
    '';
  };
}
