{ config, lib, pkgs, ... }:

with lib;

let
  hmTypes = import <home-manager/modules/lib/types.nix> { inherit lib; };

  cfg = config.profiles.dev;

  # androidSdk = androidPkgs.sdk.canary (p: with p; [
  #   tools
  #   build-tools-29-0-0
  #   platform-tools
  #   platforms.android-29
  #   emulator
  #   system-images.android-29.google_apis_playstore.x86
  # ]);

in {
  options.profiles.dev = {
    enable = mkEnableOption "dev tools";

    android = {
      enable = mkEnableOption "android dev tools";
      sdk = {
        channel = mkOption {
          type = types.enum [ "stable" "beta" "preview" "canary" ];
          default = "stable";
          description = "Channel to use for Android SDK packages.";
        };
        packages = mkOption {
          default = self: [ self.tools ];
          type = hmTypes.selectorFunction;
          defaultText = "sdk: [ sdk.tools ]";
          example = literalExample "sdk: [ sdk.build-tools-29-0-1 sdk.tools ]";
          description = "Android SDK packages to install.";
        };
        finalPackage = mkOption {
          type = types.package;
          visible = false;
          readOnly = true;
          description = ''
            The Android SDK package including SDK packages.
          '';
        };
      };
    };
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
          androidStudioPackages.beta
          androidStudioPackages.canary
          cfg.android.sdk.finalPackage
          gitRepo
        ];

        xdg.dataFile."android".source = "${cfg.android.sdk.finalPackage}/share/android-sdk";

        pam.sessionVariables = {
          ANDROID_HOME = "${config.xdg.dataHome}/android";
          ANDROID_SDK_ROOT = "${config.xdg.dataHome}/android";
        };

        profiles.dev.android.sdk.finalPackage = 
          (import <android> {}).sdk.${cfg.android.sdk.channel}
            cfg.android.sdk.packages;

        programs.chromium.extensions = [
          "hgcbffeicehlpmgmnhnkjbjoldkfhoin" # Android SDK Search
        ];
    })

    (mkIf cfg.go.enable {
      programs.go = {
        enable = true;
        goPath = "${config.xdg.dataHome}/go";
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

      pam.sessionVariables = {
        GOPATH = config.programs.go.goPath;
      };
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
