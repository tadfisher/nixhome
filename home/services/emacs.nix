{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.emacs;

  emacs = config.programs.emacs.finalPackage;

  editorScript = pkgs.writeScriptBin "emacseditor" ''
    #!${pkgs.runtimeShell}
    ${emacs}/bin/emacsclient ${concatStringsSep " " cfg.client.arguments} "$@"
  '';

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
    home.packages = [ editorScript ];

    home.sessionVariables = optionalAttrs cfg.defaultEditor {
      EDITOR = "${editorScript}/bin/emacseditor";
      VISUAL = "${editorScript}/bin/emacseditor";
    };

    services.emacs = {
      client = {
        enable = true;
      };
      socketActivation = {
        enable = true;
      };
    };
  };
}
