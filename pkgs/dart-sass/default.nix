{ stdenv, fetchFromGitHub, runtimeShell, makeWrapper, dart }:

let
  version = "1.26.10";

  src = fetchFromGitHub {
    owner = "sass";
    repo = "dart-sass";
    rev = version;
    sha256 = "0qnqjd1ny8cm0jzd9fjacf12628ilc7py9p0fziww0d6n70cgrr0";
  };

  deps = stdenv.mkDerivation rec {
    pname = "dart-sass-deps";
    inherit version src;

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "1fx8x0cb6cb8ps4jhly7b4bprg238fral1dhgpwn3k0qzsn2z5rf";

    buildPhase = ''
      cp ${./pubspec.lock} pubspec.lock
      chmod +w pubspec.lock
      mkdir .nix-pub-cache
      PUB_CACHE=.nix-pub-cache ${dart}/bin/pub get --no-precompile
    '';

    installPhase = ''
      mkdir -p $out
      cp -R .nix-pub-cache/* $out
    '';
  };

in

stdenv.mkDerivation rec {
  pname = "dart-sass";
  inherit version src;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ dart ];

  buildPhase = ''
    cp ${./pubspec.lock} pubspec.lock
    chmod +w pubspec.lock
    PUB_CACHE=${deps} pub get --offline --no-precompile
    mkdir build
    dart -Dversion=${version} --snapshot=build/sass.snapshot bin/sass.dart
  '';

  installPhase = ''
    mkdir -p $out/{bin,lib/dart/${pname}}

    cp build/sass.snapshot $out/lib/dart/${pname}/sass.snapshot

    makeWrapper "${dart}/bin/dart" "$out/bin/sass" \
      --argv0 sass \
      --add-flags "$out/lib/dart/${pname}/sass.snapshot"
  '';

  meta = with stdenv.lib; {
    description = "The reference implementation of Sass, written in Dart.";
    homepage = "https://sass-lang.com/dart-sass";
    platforms = dart.meta.platforms;
    maintainers = [ maintainers.tadfisher ];
  };
}
