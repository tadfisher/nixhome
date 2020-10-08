{ pkgs ? import <nixpkgs> {},
  super ? import <nixpkgs> {}
}:

with pkgs;

rec {
  androidStudioPackages = super.androidStudioPackages
                          // (callPackage ./android-studio {});

  base16-builder-go = callPackage ./base16-builder-go {};

  clang-tools = super.clang-tools.override {
    llvmPackages = llvmPackages_10;
  };

  corefreq = callPackage ./corefreq {};

  fetchsteam = callPackage ./fetchsteam {};

  dart-sass = callPackage ./dart-sass {};

  dotxcompose = callPackage ./dotxcompose {};

  dxvk = callPackage ./dxvk {
    stdenv = stdenv_32bit;
    wine = wine-staging;
  };

  faudio = callPackage ./faudio {};

  # https://github.com/mickeynp/ligature.el/issues/10#issuecomment-690049372
  emacs = super.emacs.overrideAttrs (attrs: {
    patches = (attrs.patches or []) ++ [
      (fetchpatch {
        url = "https://git.savannah.gnu.org/cgit/emacs.git/patch/?id=fe903c5ab7354b97f80ecf1b01ca3ff1027be446";
        sha256 = "0zldjs8nx26x7r8pwjc995lvpg06iv52rq4cy1w38hxhy7vp8lp3";
      })
    ];
  });

  emacsPackagesCustom = epkgs: epkgs.overrideScope' (self: super: {
    base16-plata-theme = self.callPackage ./emacs/base16-plata-theme {};
    ligature = self.callPackage ./emacs/ligature {};
    pretty-tabs = self.callPackage ./emacs/pretty-tabs {};
    org-cv = self.callPackage ./emacs/org-cv {};

    inherit (self.callPackage ./emacs/gnome-shell-mode {})
      company-gnome-shell
      gnome-shell-mode;
  });

  gnomeExtensionsCustom = callPackage ./gnome/extensions.nix {};

  hidrd = callPackage ./hidrd {};

  fakeos = callPackage ./fakeos {};

  firefox-gnome-theme = callPackage ./firefox/firefox-gnome-theme {};

  firefox-plata-theme = callPackage ./firefox/firefox-plata-theme {};

  gradle2nix = import ./gradle2nix;

  nautilus-admin = gnome3.callPackage ./gnome/nautilus-admin.nix {};

  gnupg-pkcs11-scd = callPackage ./gnupg-pkcs11-scd {};

  gtk4 = callPackage ./gtk/4.x.nix {
    inherit (darwin.apple_sdk.frameworks) AppKit Cocoa;
    inherit (gst_all_1) gstreamer gst-plugins-bad gst-plugins-base;
    inherit (python3Packages) libxslt;
  };

  inset = callPackage ./inset {};

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

  pass-git-helper = python3Packages.callPackage ./pass-git-helper {};

  python-3dsconv = python3Packages.callPackage ./3dsconv {};

  sass-migrator = callPackage ./sass-migrator {};

  mopidy-youtube-music = callPackage ./mopidy/youtube.nix {};
}
