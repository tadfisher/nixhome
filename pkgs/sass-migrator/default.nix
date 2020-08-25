{ stdenv, fetchFromGitHub, runtimeShell, makeWrapper, dart }:

let
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "sass";
    repo = "migrator";
    rev = version;
    sha256 = "0n1fjivk4254q36f99hg4n7ipvzdxg0prj7gnwpax4hl5r2k11vi";
  };

  deps = stdenv.mkDerivation rec {
    pname = "sass-migrator-deps";
    inherit version src;

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "0s95np9qncy9r7wvvcasc76zs5bin4sjxx8c46chii86b44fgrwz";

    buildPhase = ''
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
  pname = "sass-migrator";
  inherit version src;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ dart ];

  buildPhase = ''
    PUB_CACHE=${deps} pub get --offline --no-precompile
    mkdir build
    dart -Dversion=${version} --snapshot=build/sass-migrator.snapshot bin/sass_migrator.dart
  '';

  installPhase = ''
    mkdir -p $out/{bin,lib/dart/${pname}}

    cp build/sass-migrator.snapshot $out/lib/dart/${pname}/sass-migrator.snapshot

    makeWrapper "${dart}/bin/dart" "$out/bin/sass-migrator" \
      --argv0 sass-migrator \
      --add-flags "$out/lib/dart/${pname}/sass-migrator.snapshot"
  '';

  meta = with stdenv.lib; {
    description = "Tool for migrating stylesheets to new Sass versions";
    homepage = "https://sass-lang.com/documentation/cli/migrator";
    platforms = dart.meta.platforms;
    maintainers = [ maintainers.tadfisher ];
  };
}
