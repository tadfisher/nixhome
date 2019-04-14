self: super: {
  # steam = let
  #   pkgs = import <nixpkgs> { overlays = [(self: super: {
  #     mesa_noglu = super.mesa_noglu.override {
  #       llvmPackages = super.llvmPackages_7;
  #     };
  #   })]; };
  # in pkgs.steam;
  # steam = super.steam.override { nativeOnly = true; };
}
