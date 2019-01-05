{ stdenv, callPackage, git }:

let
  androidSdk = callPackage ./generic.nix { };

in {
  android-sdk-p = androidSdk rec {
     version = "9.0.0_r10";
     sha256 = "13v8g6zwnvvakxi764pnn0k3zn5r3zh0h7vmqak91a5g11zhi0ry";
  };
}
