{ stdenv, fetchzip, pkgs }:

let

  inherit (builtins) fromJSON head mapAttrs match readFile;

  extensionsMap = fromJSON (readFile ./extensions.json);

  extraArgs = {
    freon = {
      propagatedBuildInputs = with pkgs; [
        lm_sensors
        nvme-cli
        udisks2
      ];
    };
  };

  mkExtension = e:
    let args = extraArgs."${e.pname}" or {};
    in stdenv.mkDerivation ({
      inherit (e) pname uuid;

      version = toString e.version;

      src = fetchzip (e.src // {
        stripRoot = false;
      });

      installPhase = ''
        mkdir -p $out/share/gnome-shell/extensions/${e.uuid}
        cp -r * $out/share/gnome-shell/extensions/${e.uuid}
      '';

      meta = with stdenv.lib; e.meta // {
        maintainers = [ maintainers.tadfisher ];
        platforms = pkgs.gnome3.gnome-shell.meta.platforms;
      };
    } // args);

  extensions = mapAttrs (n: e: mkExtension e) extensionsMap;

in extensions // {
  paperwm = pkgs.callPackage ./paperwm.nix {};
}
