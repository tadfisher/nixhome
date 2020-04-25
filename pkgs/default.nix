{ pkgs ? import <nixpkgs> {},
  super ? import <nixpkgs> {}
}:

with pkgs;

rec {
  base16-builder-go = callPackage ./base16-builder-go {};

  clang-tools = super.clang-tools.override {
    llvmPackages = llvmPackages_10;
  };

  corefreq = callPackage ./corefreq {};

  fetchsteam = callPackage ./fetchsteam {};

  dotxcompose = callPackage ./dotxcompose {};

  dxvk = callPackage ./dxvk {
    stdenv = stdenv_32bit;
    wine = wine-staging;
  };

  faudio = callPackage ./faudio {};

  emacs27 = (emacs.override {
    withXwidgets = true;
  }).overrideAttrs (attrs: {
    name = "emacs-27.0.91";
    src = fetchurl {
      url = "https://alpha.gnu.org/gnu/emacs/pretest/emacs-27.0.91.tar.xz";
      sha256 = "1aj52fymw4iq9n5sahpb3wncm0cvshwmjr3833mirj6yhp9kv0cn";
    };
    buildInputs = attrs.buildInputs ++ [
      cairo harfbuzz gnome3.glib jansson lcms2 zlib
    ];
    patches = [
      ./emacs/clean-env.patch
      ./emacs/tramp-detect-wrapped-gvfsd.patch
    ];
  });

  emacs27-nox = ((emacs27.override {
    withX = false;
    withXwidgets = false;
    withGTK2 = false;
    withGTK3 = false;
  }).overrideAttrs(attrs: {
    name = "emacs-nox-27.0.90";
  }));

  emacsPackagesCustom = epkgs: epkgs.overrideScope' (self: super: {
    base16-plata-theme = self.callPackage ./emacs/base16-plata-theme {};
    pretty-tabs = self.callPackage ./emacs/pretty-tabs {};
    org-jira = self.callPackage ./emacs/org-jira.nix {};
  });

  fakeos = callPackage ./fakeos {};

  firefox-gnome-theme = callPackage ./firefox/firefox-gnome-theme {};

  firefox-plata-theme = callPackage ./firefox/firefox-plata-theme {};

  gnomeExtensions = callPackage ./gnome/extensions.nix {};

  gradle2nix = import ./gradle2nix;

  nautilus-admin = gnome3.callPackage ./gnome/nautilus-admin.nix {};

  gnupg-pkcs11-scd = callPackage ./gnupg-pkcs11-scd {};

  gtk4 = callPackage ./gtk/4.x.nix {
    inherit (darwin.apple_sdk.frameworks) AppKit Cocoa;
    inherit (gst_all_1) gstreamer gst-plugins-bad gst-plugins-base;
    inherit (python3Packages) libxslt;
  };

  inset = callPackage ./inset {};

  # inkscape = callPackage ./inkscape {
  #   inherit (llvmPackages) openmp;
  # };

  mkdocs-env = callPackage ./python/mkdocs-env.nix {
    python = python37;
  };

  mopidy = python3Packages.callPackage ./mopidy {};

  mopidy-gmusic = python3Packages.callPackage ./mopidy/gmusic.nix {};

  paper-icon-theme = super.paper-icon-theme.overrideAttrs (attrs: rec {
    version = "2020-03-12";
    name = "${attrs.pname}-${version}";
    src = fetchFromGitHub {
      owner = "snwh";
      repo = attrs.pname;
      rev = "aa3e8af7a1f0831a51fd7e638a4acb077a1e5188";
      sha256 = "0x6qzch4rrc8firb1dcf926j93gpqxvd7h6dj5wwczxbvxi5bd77";
    };
  });

  pythonPackages = python3Packages;

  python37 = let
    packageOverrides = pself: psuper: import ./python/default.nix {
      inherit (pkgs) mkdocs;
      python = super.python37;
    };
  in super.python37.override {
    inherit packageOverrides;
  };

  rust-analyzer = callPackage ./rust-analyzer {};
}
