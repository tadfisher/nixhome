{ stdenv, fetchFromGitHub, runtimeShell, makeWrapper, dart }:

let
  version = "1.29.0";

  src = fetchFromGitHub {
    owner = "sass";
    repo = "dart-sass";
    rev = version;
    sha256 = "1zf8ykwq1dxw5wc95ma10g3m9yk2ajbqc0r8qqx1b10h9df1w50f";
  };

  deps = stdenv.mkDerivation rec {
    pname = "dart-sass-deps";
    inherit version src;

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "065640yfz6ic8sw3mdvvf6pgvxdrfpj0z09kk8d747ga21xffbxk";

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
