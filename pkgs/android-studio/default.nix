{ stdenv, callPackage, fetchurl, makeFontsConf, gnome2 }:

let
  mkStudio = opts: callPackage (import <nixpkgs/pkgs/applications/editors/android-studio/common.nix> opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
  };
  latestVersion = {
    version = "4.2.0.13"; # "Android Studio 4.2 Canary 12"
    build = "202.6863838";
    sha256Hash = "sha256:6af9117a53f9fec0d75bba5d56b3a49e66f73ed47a5d01264178af645963a4b7";
  };
in rec {
  canary = mkStudio (latestVersion // {
    pname = "android-studio-canary";
    channel = "canary";
  });
}
