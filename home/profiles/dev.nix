{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.profiles.dev;
  androidPkgs = pkgs.callPackage (builtins.fetchTarball https://github.com/tadfisher/android-nixpkgs/archive/master.tar.gz) {};
  androidSdk = androidPkgs.sdk.canary (p: with p; [
    tools
    build-tools-29-0-0
    platform-tools
    platforms.android-29
    emulator
    system-images.android-29.google_apis_playstore.x86
  ]);

in {
  options.profiles.dev = {
    enable = mkEnableOption "dev tools";

    android.enable = mkEnableOption "android dev tools";
    go.enable = mkEnableOption "go dev tools";
    jvm.enable = mkEnableOption "jvm dev tools";
    hardware.enable = mkEnableOption "hardware dev tools";
    nix.enable = mkEnableOption "nix dev tools";
    python.enable = mkEnableOption "python dev tools";
    rust.enable = mkEnableOption "rust dev tools";
  };

  config = mkIf cfg.enable (mkMerge [
    ({
      home.packages = with pkgs; [
        gnumake
        llvmPackages.clang
      ];
    })

    (mkIf cfg.android.enable {
      home.packages = with pkgs; [
        androidStudioPackages.stable
        androidStudioPackages.canary
        androidSdk
        gitRepo
      ];
      pam.sessionVariables = {
        ANDROID_HOME = "${androidSdk}/share/android-sdk";
      };
    })

    (mkIf cfg.go.enable {
      programs.go = {
        enable = true;
        goPath = ".go";
      };

      home.packages = with pkgs; [
        go2nix
        dep
        go-langserver
        gocode
        godef
        gotools
        # gogetdoc
        gotests
        gopkgs
        # reftools
        # impl
      ];
    })

    (mkIf cfg.jvm.enable {
      home.packages = with pkgs; [
        gradle
        gradle-completion
        jetbrains.idea-community
      ];

      pam.sessionVariables = {
        JAVA_HOME = "${pkgs.openjdk8.home}";
      };
    })

    (mkIf cfg.nix.enable {
      home.packages = with pkgs; [
        binutils
        nix-index
        nix-prefetch-scripts
        nix-prefetch-github
        nox
        patchelf
      ];
    })

    (mkIf cfg.python.enable {
      home.packages = with pkgs; [
        python3
      ];
    })

    (mkIf cfg.hardware.enable {
      home.packages = with pkgs;[
        acpica-tools
        binutils-unwrapped
        dmidecode
        fwts
      ];
    })
  ]);
}
