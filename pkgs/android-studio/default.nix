{ stdenv, callPackage, fetchurl, makeFontsConf, gnome2 }:

let
  mkStudio = opts: callPackage (import <nixpkgs/pkgs/applications/editors/android-studio/common.nix> opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
  };
  latestVersion = {
    version = "4.2.0.15";
    build = "202.6922807";
    sha256Hash = "sha256:3d714d9cf4896dda7d36d90c0d1dd5abebe95aa77ce48a361665cf8512d193ff";
  };
in rec {
  canary = mkStudio (latestVersion // {
    pname = "android-studio-canary";
    channel = "canary";
  });
}
