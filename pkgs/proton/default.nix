{ stdenv, lib, fetchFromGitHub
, wine32, wine64,
, steam-runtime-wrapped, steam-runtime-wrapped-i686
, ffmpeg, faudio
, }:

# Deps:
# wine 32/64 (gecko32/64, wine-mono)
# steam runtime
# ffmpeg
# faudio
# lsteamclient (local)
# steamhelper (local)
# vrclient (local)
# dxvk
# cmake
# bison
# fonts (?)

stdenv.mkDerivation rec {
  pname = "proton";
  version = "4.11-4";

  src = fetchFromGitHub {
    owner = "ValveSoftware";
    repo = "Proton";
    rev = "proton-${version}";
    fetchSubmodules = true;
    sha256 = lib.fakeSha256;
  };

  
}
