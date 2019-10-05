{ pkgs ? import <nixpkgs> {},
  super ? import <nixpkgs> {}
}:

with pkgs;

rec {
  base16-builder-go = callPackage ./base16-builder-go {};

  corefreq = callPackage ./corefreq {};

  fetchsteam = callPackage ./fetchsteam {};

  dxvk = callPackage ./dxvk {
    stdenv = stdenv_32bit;
    wine = wine-staging;
  };

  faudio = callPackage ./faudio {};

  emacsPackagesCustom = epkgs: with epkgs; {
    base16-plata-theme = callPackage ./emacs/base16-plata-theme {};
    org-jira = callPackage ./emacs/org-jira.nix {};
  };

  fakeos = callPackage ./fakeos {};

  gnomeExtensions = callPackage ./gnome/extensions.nix {};

  nautilus-admin = gnome3.callPackage ./gnome/nautilus-admin.nix {};

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
