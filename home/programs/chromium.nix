{ config, lib, pkgs, ... }:

{
  programs.chromium = {
    package = pkgs.chromium.override {
      commandLineArgs = [ "--enable-viz" ];
      pulseSupport = true;
    };
    extensions = [
      "naepdomgkenhinolocfifgehidddafch" # browserpass-ce
      "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" # Privacy Badger
    ];
  };
}
