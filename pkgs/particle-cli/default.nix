{
  pkgs ? import <nixpkgs> { inherit system; },
  system ? builtins.currentSystem,
  nodejs ? pkgs.nodejs,
  nodePkgs ? pkgs.nodePackages
}:

let
  nodePackages = import ./particle-cli.nix {
    inherit pkgs system nodejs;
  };
in
nodePackages // {
  particle-cli = nodePackages.particle-cli.override (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [ nodePkgs.node-gyp ];
  });
}
