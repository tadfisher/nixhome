{ stdenv, fetchFromGitHub, buildPythonApplication
, mopidy, pykka, setuptools, gmusicapi, requests, cachetools }:

buildPythonApplication rec {
  pname = "mopidy-gmusic";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = pname;
    rev = "v${version}";
    sha256 = "08xi0pn1zvkfy1d27pll1dwj2m08mdf07g1bw4aqz2p59vy67v6v";
  };

  propagatedBuildInputs = [
    mopidy
    pykka
    setuptools
    gmusicapi
    requests
    cachetools
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://www.mopidy.com/;
    description = "Mopidy extension for playing music from Google Play Music";
    license = licenses.asl20;
    maintainers = [ maintainers.jgillich ];
    hydraPlatforms = [];
  };
}
