{ config, lib, ... }:

with lib;

let
  cfg = config.programs.emacs.init.lsp;
  pkgCfg = config.programs.emacs.init.usePackage;

  lspModule = types.submodule ({ name, config, ... }: {
    options = {
      require = mkOption {
        type = types.str;
        default = "lsp-${name}";
        description = ''
          Built-in LSP module to require. Use <option>emacsPackages</option>
          for external clients.
        '';
      };

      emacsPackages = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "lsp-haskell" ];
        description = ''
          Emacs packages required for this client.
        '';
      };

      modes = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "c-mode" "c++-mode" ];
        description = ''
          Emacs modes for which to start the LSP client.
        '';
      };

      executables = mkOption {
        type = types.attrsOf types.str;
        default = {};
        example = literalExample ''
          { typescript-language-server = "''${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
            typescript = "''${pkgs.nodePackages.typescript}/bin/tsserver";
          }
        '';
        description = ''
          Set of paths to binaries required by the LSP client.
        '';
      };

      config = mkOption {
        type = types.lines;
        default = "";
        example = literalExample ''
          (setq lsp-clients-clangd-executable "''${pkgs.clang-tools}/bin/clangd")
        '';
        description = ''
          Extra Emacs Lisp configuration for this LSP client.
        '';
      };

      packages = mkOption {
        type = types.listOf types.package;
        default = [];
        example = literalExample ''
          [ pkgs.nodePackages.bash-language-server ];
        '';
        description = ''
          Packages to make available in the home profile.
        '';
      };
    };
  });

  flatMap = f: flatten (map f (attrValues cfg.clients));

  requirePackages = concatStringsSep " "
    (map (c: c.require) (attrValues cfg.clients));

  mkModes = c: map (m: "(${m} . lsp)") c.modes;

  mkDeps =
    let
      mkDep = c: mapAttrsToList
        (n: v: ''(lsp-dependency '${n} '(:system "${v}"))'')
        c.executables;
      deps = flatMap mkDep;
    in
      if (deps == [])
      then ""
      else ''
        (eval-after-load 'lsp-clients
	  '(progn
            ${concatStringsSep "\n" deps}))
      '';

  mkInit = concatStringsSep "\n" (
    [ "(setq lsp-client-packages '(${requirePackages}))" ]
    ++ map (c: c.config) (attrValues cfg.clients)
    ++ [ mkDeps ]
  );

  mkUsePackages = genAttrs (flatMap (c: c.emacsPackages)) (p: { enable = true; });

in

{
  options = {
    programs.emacs.init.lsp = {
      enable = mkEnableOption "emacs-lsp clients";

      clients = mkOption {
        type = types.attrsOf lspModule;
        default = {};
        example = literalExample ''
          {
            "bash" = {
              modes = [ "sh-mode" ];
              packages = [ pkgs.nodePackages.bash-language-server ];
            };
          }
        '';
        description = ''
          Language Server Protocol clients to configure.
        '';
      };

      init = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra code for lsp-mode's <option>:init</option>.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = flatMap (c: c.packages);

    programs.emacs.init.usePackage = {
      lsp-mode = {
        enable = true;
        after = [ "lsp-ui" ];
        command = [ "lsp" ];
        hook = (optional pkgCfg.which-key.enable "(lsp-mode . lsp-enable-which-key-integration)")
               ++ flatMap mkModes;
        init = ''
          ${cfg.init}
        '';
        config = ''
          ${mkInit}
        '';
      };
    } // mkUsePackages;
  };
}
