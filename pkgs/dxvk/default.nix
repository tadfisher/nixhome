{ stdenv, buildEnv, fetchFromGitHub, meson, ninja, wine, glslang }:


let

  mkArch = arch: stdenv.mkDerivation rec {
    pname = "dxvk";
    version = "1.3.4";

    src = fetchFromGitHub {
      owner = "doitsujin";
      repo = "dxvk";
      rev = "v${version}";
      sha256 = "0r7vcig0scnh22lll5a0zivlq1pmg24jrxb0ga1digvj3r31nn8f";
    };

    nativeBuildInputs = [ meson ninja ];

    buildInputs = [ wine glslang ];

    mesonBuildType = "release";

    mesonFlags = [
      "--libdir=lib${arch}"
      "--cross-file=build-wine${arch}.txt"
    ];

    installPhase = ''
      mkdir -p $out
      cp -r lib${arch} $out
    '';
  };

  dxvk32 = mkArch "32";
  dxvk64 = mkArch "64";

in

if stdenv.hostPlatform.is32bit
then dxvk32
else buildEnv {
  name = "dxvk-multi-env";
  paths = [ dxvk32 dxvk64 ];
}
