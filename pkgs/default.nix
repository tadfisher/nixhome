{ pkgs ? import <nixpkgs> {},
  super ? import <nixpkgs> {}
}:

with pkgs;

{
  base16-builder-go = callPackage ./base16-builder-go {};

  corefreq = callPackage ./corefreq {};

  fetchsteam = callPacakge ./fetchsteam {};

  emacsPackagesCustom = epkgs: with epkgs; {
    base16-plata-theme = callPackage ./emacs/base16-plata-theme {};
    org-jira = callPackage ./emacs/org-jira.nix {};
  };

  fakeos = callPackage ./fakeos {};

  gnomeExtensions = super.gnomeExtensions // {
    freon = callPackage ./gnome/freon.nix {};
    top-panel-workspace-scroll = callPackage ./gnome/top-panel-workspace-scroll.nix {};
  };

  gnupg-pkcs11-scd = callPackage ./gnupg-pkcs11-scd {};

  inset = callPackage ./inset {};

  mkdocs-env = callPackage ./python/mkdocs-env.nix {
    python = python37;
  };

  python37 = let
    packageOverrides = pself: psuper: import ./python/default.nix {
      inherit (pkgs) mkdocs;
      python = super.python37;
    };
  in super.python37.override {
    inherit packageOverrides;
  };

  rust-analyzer = callPackage ./rust-analyzer {};

  simpleburn = callPackage ./simpleburn {};
}
