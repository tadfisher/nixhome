{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.emacs;

  emacs = config.programs.emacs.package;

  editorScript = pkgs.writeScriptBin "emacseditor" ''
    #!${pkgs.runtimeShell}
    if [ -z "$1" ]; then
      exec ${emacs}/bin/emacsclient --create-frame --alternate-editor ${emacs}/bin/emacs
    else
      exec ${emacs}/bin/emacsclient --alternate-editor ${emacs}/bin/emacs "$@"
    fi
  '';

  desktopItem = pkgs.makeDesktopItem {
    name = "emacs";
    exec = "emacseditor %U";
    icon = "emacs";
    comment = "Edit text";
    desktopName = "Emacs";
    genericName = "Text Editor";
    mimeType = "text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;";
    categories = "Development;TextEditor;";
    extraEntries = ''
      StartupWMClass=Emacs
      Keywords=Text;Editor;
    '';
  };

in {

  options.services.emacs.defaultEditor = mkOption {
    type = types.bool;
    default = false;
    description = ''
      When enabled, configures emacsclient to be the default editor
      using the EDITOR environment variable.
    '';
  };

  config = mkIf cfg.enable {
    home.packages = [
      editorScript
      desktopItem
    ];

    pam.sessionVariables = optionalAttrs cfg.defaultEditor {
      EDITOR = "${editorScript}/bin/emacseditor";
      VISUAL = "${editorScript}/bin/emacseditor";
    };

    xdg.dataFile."applications/emacs.desktop".source = "${desktopItem}/share/applications/emacs.desktop";
  };
}
