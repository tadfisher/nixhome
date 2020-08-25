{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.emacs.init;

  packageFunctionType = mkOptionType {
    name = "packageFunction";
    description = "function from epkgs to package";
    check = isFunction;
    merge = mergeOneOption;
  };

  hydraHeadType = types.submodule ({ name, config, ... }: {
    options = {
      command = mkOption {
        type = types.str;
      };

      hint = mkOption {
        type = types.nullOr types.str;
        default = null;
      };

      exit = mkOption {
        type = types.bool;
        default = false;
      };

      color = mkOption {
        type = types.nullOr (types.enum [ "red" "blue" "amaranth" "teal" "pink" ]);
        default = null;
      };

      bind = mkOption {
        type = types.lines;
        default = "";
      };

      column = mkOption {
        type = types.str;
        default = "";
      };

      assembly = mkOption {
        type = types.lines;
        readOnly = true;
        internal = true;
        description = "The final :mode-hydra code for a head.";
      };
    };

    config = {
      assembly =
        let
          quoted = v: ''"${escape ["\""] v}"'';
          mkHint = v: optional (v != null)
            (if v != "" then "${quoted v}" else "nil");
          mkExit = v: optional v ":exit t";
          mkColor = v: optional (v != null) ":color ${v}";
          mkBind = v: optional (v != "") ":bind ${v}";
          mkColumn = v: optional (v != "") ":column ${quoted v}";
        in
          concatStringsSep "\n  " (
            [ "(${quoted name} ${config.command}" ]
            ++ mkHint config.hint
            ++ mkExit config.exit
            ++ mkColor config.color
            ++ mkBind config.bind
            ++ [ ")" ]
          );
    };
  });

  modeHydraType = types.submodule ({ name, config, ... }: {
    options = {
      title = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Title of the major-mode hydra.
        '';
      };

      formatter = mkOption {
        type = types.str;
        default = "";
      };

      quitKey = mkOption {
        type = types.str;
        default = "";
      };

      toggle = mkOption {
        type = types.either types.bool types.str;
        default = false;
      };

      pre = mkOption {
        type = types.lines;
        default = "";
      };

      post = mkOption {
        type = types.lines;
        default = "";
      };

      exit = mkOption {
        type = types.bool;
        default = false;
      };

      foreignKeys = mkOption {
        type = types.enum [ "nil" "warn" "run" ];
        default = "nil";
      };

      color = mkOption {
        type = types.nullOr (types.enum [ "red" "blue" "amaranth" "teal" "pink" ]);
        default = null;
      };

      timeout = mkOption {
        type = types.ints.unsigned;
        default = 0;
      };

      hint = mkOption {
        type = types.nullOr types.str;
        default = null;
      };

      bind = mkOption {
        type = types.str;
        default = "";
      };

      baseMap = mkOption {
        type = types.str;
        default = "";
      };

      heads = mkOption {
        type = types.attrsOf (types.attrsOf hydraHeadType);
        default = {};
        example = literalExample ''
          {
            Doc = {
              d = {
                command = "godoc-at-point";
                description = "doc at point";
              };
            };
          }
        '';
        description = ''
          Attribute set of hydra heads.
        '';
      };

      assembly = mkOption {
        type = types.lines;
        readOnly = true;
        internal = true;
        description = "The final :mode-hydra code.";
      };
    };

    config = {
      assembly =
        let
          quoted = v: ''"${escape ["\""] v}"'';
          mkTitle = v: optional (v != null) ":title ${quoted v}";
          mkFormatter = v: optional (v != "") ":formatter ${v}";
          mkQuitKey = v: optional (v != "") ":quit-key ${quoted v}";
          mkToggle = v: if (builtins.isBool v)
                      then optional v ":toggle t"
                      else ":toggle ${v}";
          mkPre = v: optional (v != "") ":pre ${v}";
          mkPost = v: optional (v != "") ":post ${v}";
          mkExit = v: optional v ":exit t";
          mkForeignKeys = v: optional (v != "nil") ":foreign-keys ${v}";
          mkColor = v: optional (v != null) ":color ${v}";
          mkTimeout = v: optional (v != 0) ":timeout ${toString v}";
          mkHint = v: optional (v != null) ":hint ${
            if v == "" then "nil" else quoted v
          }";
          mkBind = v: optional (v != "") ":bind ${v}";
          mkBaseMap = v: optional (v != "") ":base-map ${v}";
          mkHeads = hs:
            let
              mkHead = n: vs:
                [ "(${quoted n} (" ]
                ++ mapAttrsToList (n: v: v.assembly) vs
                ++ [ "))" ];
              in
                flatten (mapAttrsToList mkHead hs);
        in
          concatStringsSep "\n  " (
            [ "(${name}" ]
            ++ mkTitle config.title
            ++ mkFormatter config.formatter
            ++ mkQuitKey config.quitKey
            ++ mkToggle config.toggle
            ++ mkPre config.pre
            ++ mkPost config.post
            ++ mkExit config.exit
            ++ mkForeignKeys config.foreignKeys
            ++ mkColor config.color
            ++ mkTimeout config.timeout
            ++ mkHint config.hint
            ++ mkBind config.bind
            ++ mkBaseMap config.baseMap
            ++ mkHeads config.heads
            ++ [ ")" ]
          );
    };
  });

  usePackageType = types.submodule ({ name, config, ... }: {
    options = {
      enable = mkEnableOption "Emacs package ${name}";

      package = mkOption {
        type =
          types.either
            (types.str // { description = "name of package"; })
            packageFunctionType;
        default = name;
        description = ''
          The package to use for this module. Either the package name
          within the Emacs package set or a function taking the Emacs
          package set and returning a package.
        '';
      };

      defer = mkOption {
        type = types.either types.bool types.ints.positive;
        default = false;
        description = ''
          The <option>:defer</option> setting.
        '';
      };

      demand = mkOption {
        type = types.bool;
        default = false;
        description = ''
          The <option>:demand</option> setting.
        '';
      };

      diminish = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          The entries to use for <option>:diminish</option>.
        '';
      };

      chords = mkOption {
        type = types.attrsOf types.str;
        default = {};
        example = { "jj" = "ace-jump-char-mode"; "jk" = "ace-jump-word-mode"; };
        description = ''
          The entries to use for <option>:chords</option>.
        '';
      };

      mode = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          The entries to use for <option>:mode</option>.
        '';
      };

      after = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          The entries to use for <option>:after</option>.
        '';
      };

      bind = mkOption {
        type = types.attrsOf types.str;
        default = {};
        example = { "M-<up>" = "drag-stuff-up"; "M-<down>" = "drag-stuff-down"; };
        description = ''
          The entries to use for <option>:bind</option>.
        '';
      };

      bindLocal = mkOption {
        type = types.attrsOf (types.attrsOf types.str);
        default = {};
        example = { helm-command-map = { "C-c h" = "helm-execute-persistent-action"; }; };
        description = ''
          The entries to use for local keymaps in <option>:bind</option>.
        '';
      };

      bindKeyMap = mkOption {
        type = types.attrsOf types.str;
        default = {};
        example = { "C-c p" = "projectile-command-map"; };
        description = ''
          The entries to use for <option>:bind-keymap</option>.
        '';
      };

      command = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          The entries to use for <option>:commands</option>.
        '';
      };

      config = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Code to place in the <option>:config</option> section.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Additional lines to place in the use-package configuration.
        '';
      };

      hook = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          The entries to use for <option>:hook</option>.
        '';
      };

      init = mkOption {
        type = types.lines;
        default = "";
        description = ''
          The entries to use for <option>:init</option>.
        '';
      };

      modeHydra = mkOption {
        type = types.attrsOf modeHydraType;
        default = {};
        description = ''
          The entries to use for <option>:mode-hydra</option>.
        '';
      };

      assembly = mkOption {
        type = types.lines;
        readOnly = true;
        internal = true;
        description = "The final use-package code.";
      };
    };

    config = mkIf config.enable {
      assembly =
        let
          quoted = v: ''"${escape ["\""] v}"'';
          mkBindHelper = cmd: prefix: bs:
            optionals (bs != {}) (
              [ ":${cmd} (${prefix}" ]
              ++ mapAttrsToList (n: v: "  (${quoted n} . ${v})") bs
              ++ [ ")" ]
          );

          mkAfter = vs: optional (vs != []) ":after (${toString vs})";
          mkCommand = vs: optional (vs != []) ":commands (${toString vs})";
          mkDiminish = vs: optional (vs != []) ":diminish (${toString vs})";
          mkMode = map (v: ":mode ${v}");
          mkBind = mkBindHelper "bind" "";
          mkBindLocal = bs:
            let
              mkMap = n: v: mkBindHelper "bind" ":map ${n}" v;
            in
              flatten (mapAttrsToList mkMap bs);
          mkBindKeyMap = mkBindHelper "bind-keymap" "";
          mkChords = mkBindHelper "chords" "";
          mkModeHydra = vs:
            flatten (mapAttrsToList (n: v: ":mode-hydra ${v.assembly}") vs);
          mkHook = map (v: ":hook ${v}");
          mkDefer = v:
            if isBool v then optional v ":defer t"
            else [ ":defer ${toString v}" ];
          mkDemand = v: optional v ":demand t";
        in
          concatStringsSep "\n  " (
            [ "(use-package ${name}" ]
            ++ mkAfter config.after
            ++ mkBind config.bind
            ++ mkBindKeyMap config.bindKeyMap
            ++ mkBindLocal config.bindLocal
            ++ mkChords config.chords
            ++ mkCommand config.command
            ++ mkDefer config.defer
            ++ mkDemand config.demand
            ++ mkDiminish config.diminish
            ++ mkHook config.hook
            ++ mkMode config.mode
            ++ mkModeHydra config.modeHydra
            ++ optionals (config.init != "") [ ":init" config.init ]
            ++ optionals (config.config != "") [ ":config" config.config ]
            ++ optional (config.extraConfig != "") config.extraConfig
          ) + ")";
    };
  });

  usePackageStr = name: pkgConfStr: ''
    (use-package ${name}
      ${pkgConfStr})
  '';

  mkRecommendedOption = type: extraDescription: mkOption {
    type = types.bool;
    default = false;
    example = true;
    description = ''
      Whether to enable recommended ${type} settings.
    '' + optionalString (extraDescription != "") ''
      </para><para>
      ${extraDescription}
    '';
  };

  # Recommended GC settings.
  gcSettings = ''
    (defun hm/reduce-gc ()
      "Reduce the frequency of garbage collection."
      (setq gc-cons-threshold 402653184
            gc-cons-percentage 0.6))

    (defun hm/restore-gc ()
      "Restore the frequency of garbage collection."
      (setq gc-cons-threshold 16777216
            gc-cons-percentage 0.1))

    ;; Make GC more rare during init and while minibuffer is active.
    (eval-and-compile #'hm/reduce-gc)
    (add-hook 'minibuffer-setup-hook #'hm/reduce-gc)

    ;; But make it more regular after startup and after closing minibuffer.
    (add-hook 'emacs-startup-hook #'hm/restore-gc)
    (add-hook 'minibuffer-exit-hook #'hm/restore-gc)

    ;; Avoid unnecessary regexp matching while loading .el files.
    (defvar hm/file-name-handler-alist file-name-handler-alist)
    (setq file-name-handler-alist nil)

    (defun hm/restore-file-name-handler-alist ()
      "Restores the file-name-handler-alist variable."
      (setq file-name-handler-alist hm/file-name-handler-alist)
      (makunbound 'hm/file-name-handler-alist))

    (add-hook 'emacs-startup-hook #'hm/restore-file-name-handler-alist)
  '';

  # Whether the configuration makes use of `:diminish`.
  hasDiminish = any (p: p.diminish != []) (attrValues cfg.usePackage);

  # Whether the configuration makes use of `:bind`.
  hasBind = any (p: p.bind != {}) (attrValues cfg.usePackage);

  # Whether the configuration makes use of `:chords`.
  hasChords = any ( p: p.chords != {}) (attrValues cfg.usePackage);

  # Whether the configuration makes use of ':mode-hydra'.
  hasModeHydra = any (p: p.modeHydra != {}) (attrValues cfg.usePackage);

  usePackageSetup =
    ''
      (eval-when-compile
        (require 'package)

        (setq package-archives nil
              package-enable-at-startup nil
              package--init-file-ensured t)

        (require 'use-package)

        ;; To help fixing issues during startup.
        (setq use-package-verbose ${
          if cfg.usePackageVerbose then "t" else "nil"
        }))
    ''
    + optionalString hasDiminish ''
      ;; For :diminish in (use-package).
      (require 'diminish)
    ''
    + optionalString hasBind ''
      ;; For :bind in (use-package).
      (require 'bind-key)
    ''
    + optionalString hasChords ''
      ;; For :chords in (use-package).
      (use-package use-package-chords
        :config (key-chord-mode 1))
    ''
    + optionalString hasModeHydra ''
      ;; For :mode-hydra in (use-package).
      (use-package major-mode-hydra
        :bind ("${cfg.majorModeHydraKey}" . major-mode-hydra))
    '';

  initFile = ''
    ;;; hm-init.el --- Emacs configuration à la Home Manager.
    ;;
    ;; -*- lexical-binding: t; -*-
    ;;
    ;;; Commentary:
    ;;
    ;; A configuration generated from a Nix based configuration by
    ;; Home Manager.
    ;;
    ;;; Code:

    ${optionalString cfg.startupTimer ''
      ;; Remember when configuration started. See bottom for rest of this.
      ;; Idea taken from http://writequit.org/org/settings.html.
      (defconst emacs-start-time (current-time))
    ''}

    ${optionalString cfg.recommendedGcSettings gcSettings}

    ${cfg.prelude}

    ${usePackageSetup}
  ''
  + concatStringsSep "\n\n"
    (map (getAttr "assembly")
    (filter (getAttr "enable")
    (attrValues cfg.usePackage)))
  + ''

    ${cfg.postlude}

    ${optionalString cfg.startupTimer ''
      ;; Make a note of how long the configuration part of the start took.
      (let ((elapsed (float-time (time-subtract (current-time)
                                                emacs-start-time))))
        (message "Loading settings...done (%.3fs)" elapsed))
    ''}

    (provide 'hm-init)
    ;; hm-init.el ends here
  '';

in

{
  options.programs.emacs.init = {
    enable = mkEnableOption "Emacs configuration";

    majorModeHydraKey = mkOption {
      type = types.str;
      default = "M-SPC";
      description = ''
        Key binding to activate major-mode-hydra.
      '';
    };

    recommendedGcSettings = mkRecommendedOption "garbage collection" ''
      This will reduce garbage collection frequency during startup and
      while the minibuffer is active.
    '';

    startupTimer = mkEnableOption "Emacs startup duration timer";

    prelude = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Configuration lines to add in the beginning of
        <filename>init.el</filename>.
      '';
    };

    postlude = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Configuration lines to add in the end of
        <filename>init.el</filename>.
      '';
    };

    usePackageVerbose = mkEnableOption "verbose use-package mode";

    usePackage = mkOption {
      type = types.attrsOf usePackageType;
      default = {};
      example = literalExample ''
        {
          dhall-mode = {
            mode = [ '''"\\.dhall\\'"''' ];
          };
        }
      '';
      description = ''
        Attribute set of use-package configurations.
      '';
    };
  };

  config = mkIf (config.programs.emacs.enable && cfg.enable) {
    programs.emacs.extraPackages = epkgs:
      let
        getPkg = v:
          if isFunction v
          then [ (v epkgs) ]
          else optional (isString v && hasAttr v epkgs) epkgs.${v};

        packages =
          concatMap (v: getPkg (v.package))
          (builtins.attrValues cfg.usePackage);
      in
        [
          (epkgs.trivialBuild {
            pname = "hm-init";
            version = "0";
            src = pkgs.writeText "hm-init.el" initFile;
            packageRequires =
              [ epkgs.use-package ]
              ++ packages
              ++ optional hasBind epkgs.bind-key
              ++ optional hasDiminish epkgs.diminish
              ++ optional hasChords epkgs.use-package-chords
              ++ optional hasModeHydra epkgs.major-mode-hydra;
            preferLocalBuild = true;
            allowSubstitutes = false;
          })
        ];

    home.file.".emacs.d/init.el".text = ''
      (require 'hm-init)
      (provide 'init)
    '';
  };
}
