{ config, lib, pkgs, ... }:

{
  programs.chromium = {
    package = pkgs.chromium.override {
      commandLineArgs = [ 
        "--enable-features=OverlayScrollbar"
        "--enable-native-gpu-memory-buffers"
        "--enable-gpu-rasterization"
        "--enable-oop-rasterization"
        "--ignore-gpu-blacklist"
      ];
      pulseSupport = true;
    };
    extensions = [
      "naepdomgkenhinolocfifgehidddafch" # browserpass-ce
      "afjjoildnccgmjbblnklbohcbjehjaph" # Browserpass OTP
      "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" # Privacy Badger
    ];
  };
}
