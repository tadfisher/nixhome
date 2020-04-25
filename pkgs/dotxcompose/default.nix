{ stdenv, fetchFromGitHub, perl }:

let
  composeFiles = [
    "emoji"
    "modletters"
    "tags"
    "maths"
  ];

in

stdenv.mkDerivation {
  pname = "xcompose";
  version = "20190801-unstable";

  src = fetchFromGitHub {
    owner = "kragen";
    repo = "xcompose";
    rev = "3fb0a8ce54087bddf3d266c7de59d5e524750a6a";
    sha256 = "01nv5psi4klw06hp2i9q9wjw05mj0cwibrsp78vhn2gwb0lac1vv";
  };

  nativeBuildInputs = [ perl ];

  buildPhase = ''
    for f in ${toString composeFiles}; do
      ${perl}/bin/perl emojitrans2.pl < $f-base > $f.compose
    done
  '';

  installPhase = ''
    mkdir -p $out/share
    cp dotXCompose $out/share
    for f in ${toString composeFiles}; do
      cp $f.compose $out/share
    done
  '';

  meta = with stdenv.lib; {
    description = "Shared .XCompose keybindings";
    homepage = "https://github.com/kragen/xcompose";
    platforms = platforms.all;
    license = licenses.unfree;
  };
}
