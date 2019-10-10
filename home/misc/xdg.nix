{ config, lib, pkgs, ... }:

with lib;

let
  inherit (config.home) homeDirectory;
  inherit (config.xdg) configHome;

in {
  home.file.".config/user-dirs.dirs".text = ''
    XDG_DESKTOP_DIR="${homeDirectory}"
    XDG_DOCUMENTS_DIR="${homeDirectory}/doc"
    XDG_DOWNLOAD_DIR="${homeDirectory}/download"
    XDG_MUSIC_DIR="${homeDirectory}/media/music"
    XDG_PICTURES_DIR="${homeDirectory}/media/image"
    XDG_PUBLICSHARE_DIR="${homeDirectory}/public"
    XDG_TEMPLATES_DIR="${configHome}/templates"
    XDG_VIDEOS_DIR="${homeDirectory}/media/video"
  '';

  home.extraProfileCommands = ''
    if [ -w $out/share/mime ] && [ -d $out/share/mime/packages ]; then
      XDG_DATA_DIRS=$out/share PKGSYSTEM_ENABLE_FSYNC=0 ${pkgs.buildPackages.shared-mime-info}/bin/update-mime-database -V $out/share/mime > /dev/null
    fi

    if [ -w "$out/share/applications" ] ; then
      ${pkgs.desktop-file-utils}/bin/update-desktop-database $out/share/applications
    fi
  '';
}
