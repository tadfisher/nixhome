{ config, lib, pkgs, ... }:

with lib;

let
  hmTypes = import <home-manager/modules/lib/types.nix> { inherit lib; };

  cfg = config.profiles.dev;

in {
  options.profiles.dev = {
    enable = mkEnableOption "dev tools";

    android = {
      enable = mkEnableOption "android dev tools";
      pkgs = mkOption {
        type = types.path;
        default = <android>;
        defaultText = "<android>";
        description = ''
          Path to android-nixpkgs.
        '';
      };
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

      emulator = mkOption {
        type = types.submodule {
          options = {
            enableVulkan = mkEnableOption "Vulkan support";
          };
        };
        default = {
          enableVulkan = false;
        };
        description = ''
          Settings for the Android emulator.
        '';
      };
    };
    go.enable = mkEnableOption "go dev tools";
    jvm = {
      enable = mkEnableOption "jvm dev tools";

      gradleProperties = mkOption {
        type = types.lines;
        default = "";
        description = "Gradle properties.";
      };
    };
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
        androidStudioPackages.beta
        androidStudioPackages.canary
        cfg.android.sdk.finalPackage
        gitRepo
      ];

      home.file = mkIf cfg.android.emulator.enableVulkan {
        ".android/advancedFeatures.ini".text = ''
          Vulkan = on
          GLDirectMem = on
        '';
      };

      xdg.dataFile."android".source = "${cfg.android.sdk.finalPackage}/share/android-sdk";

      pam.sessionVariables = {
        ANDROID_HOME = "${config.xdg.dataHome}/android";
        ANDROID_SDK_ROOT = "${config.xdg.dataHome}/android";
      };

      profiles.dev.android.sdk.finalPackage =
        (import cfg.android.pkgs {}).sdk.${cfg.android.sdk.channel}
          cfg.android.sdk.packages;

      profiles.dev.jvm.enable = mkDefault true;

      profiles.dev.jvm.gradleProperties = ''
          org.gradle.jvmargs=-Xms512m -Xmx4096m -XX:+CMSClassUnloadingEnabled
        '';

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
      home.file.".gradle/gradle.properties".text = cfg.jvm.gradleProperties;

      home.packages = with pkgs; [
        gradle
        gradle-completion
        jetbrains.idea-community
      ];

      pam.sessionVariables = {
        JAVA_HOME = "${pkgs.openjdk11.home}";
      };

      xdg.dataFile = {
        "java/openjdk8".source = pkgs.openjdk8.home;
        "java/openjdk11".source = pkgs.openjdk11.home;
        "java/jetbrains".source = pkgs.jetbrains.jdk;
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
        (python3.withPackages (p: with p; [
          pip
          virtualenvwrapper
        ]))
        pipenv
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
