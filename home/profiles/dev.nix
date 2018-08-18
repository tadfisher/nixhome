{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.profiles.dev;

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
        ];
    })

    (mkIf cfg.go.enable {
      home.packages = with pkgs; [
        go
        go2nix
        dep
      ];

      pam.sessionVariables = {
        GOPATH = "${config.home.homeDirectory}/.go";
      };
    })

    (mkIf cfg.jvm.enable {
      home.packages = with pkgs; [
        gradle
        gradle-completion
        jetbrains.idea-community
      ];

      pam.sessionVariables = {
        JAVA_HOME = "${pkgs.jetbrains.jdk}";
      };
    })

    (mkIf cfg.nix.enable {
      home.packages = with pkgs; [
        nix-index
        nix-prefetch-scripts
        nox
      ];
    })

    (mkIf cfg.python.enable {
      home.packages = with pkgs; [
        python3
      ];
    })

    (mkIf cfg.rust.enable {
      home.packages = with pkgs; [
        cargo
        carnix
        rustc
        rustfmt
        # TODO Broken tests
        # rustracer
      ];

      pam.sessionVariables = {
        RUST_SRC_PATH = pkgs.rustPlatform.rustcSrc;
      };
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
