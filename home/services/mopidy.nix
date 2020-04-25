{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.mopidy;

  mopidyConf = pkgs.writeText "mopidy.conf" cfg.configuration;

  mopidyEnv = with pkgs; buildEnv {
    name = "mopidy-with-extensions-${mopidy.version}";
    paths = closePropagation cfg.extensionPackages;
    pathsToLink = [ "/${python3.sitePackages}" ];
    buildInputs = [ makeWrapper ];
    postBuild = ''
      makeWrapper ${mopidy}/bin/mopidy $out/bin/mopidy \
        --argv0 mopidy \
        --add-flags "--config ${concatStringsSep ":" ([mopidyConf] ++ cfg.extraConfigFiles)}" \
        --prefix PYTHONPATH : $out/${python3.sitePackages}
    '';
  };

in {
  options = {
    services.mopidy = {
      enable = mkEnableOption "Mopidy music player daemon";

      extensionPackages = mkOption {
        default = [];
        type = types.listOf types.package;
        example = literalExample "[ pkgs.mopidy-spotify ]";
        description = ''
          Mopidy extensions that should be loaded by the service.
        '';
      };

      configuration = mkOption {
        default = "";
        type = types.lines;
        description = ''
          The configuration that Mopidy should use.
        '';
      };

      extraConfigFiles = mkOption {
        default = [];
        type = types.listOf types.str;
        description = ''
          Extra config file read by Mopidy when the service starts.
          Later files in the list override any earlier configuration.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ mopidyEnv ];

    systemd.user.services.mopidy = {
      Unit = {
        Description = "mopidy music player daemon";
        After = [ "pulseaudio.service" ];
      };

      Service = {
        ExecStart = "${mopidyEnv}/bin/mopidy";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
