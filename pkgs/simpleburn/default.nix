{ stdenv, fetchurl, cmake, pkgconfig, cdrtools, gtk3, libdvdread, libcddb, libcdio
, flac, mpg123, lame, vorbis-tools, mplayer }:

stdenv.mkDerivation rec {
  name = "simpleburn-${version}";
  version = "1.8.4";

  src = fetchurl {
    url = "http://simpleburn.tuxfamily.org/IMG/gz/simpleburn-${version}.tar.gz";
    sha256 = "1nyj7r61sjpi9s0mva7jl3x7p8jyg890kpdk5cv1vs3gsmd8xd7x";
  };

  nativeBuildInputs = [
    pkgconfig
    cmake
  ];

  buildInputs = [
    cdrtools
    gtk3
    libdvdread
    libcddb
    libcdio
    flac
    mpg123
    lame
    vorbis-tools
    mplayer
  ];
}
