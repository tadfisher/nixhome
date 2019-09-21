with import <nixpkgs> {};

let
  pkg = callPackage ./default.nix {};

in

nixBufferBuilders.withPackages (
  pkg.buildInputs or []
  ++ pkg.nativeBuildInputs or []
  ++ pkg.propagatedBuildInputs or []
  ++ pkg.propagatedNativeBuildInputs or []
)
