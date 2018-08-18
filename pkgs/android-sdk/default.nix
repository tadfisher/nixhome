{ stdenv, callPackage, git }:

let
  androidSdk = callPackage ./generic.nix { };

in {
  android-sdk-p-preview-2 = androidSdk rec {
     version = "8.1.0_r33";
     sha256 = "0a3wlcagy9widn6my9qahjymvmxd6risqk8vvdij5qvw8wiicy6k";
  };
}
