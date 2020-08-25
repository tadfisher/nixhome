{ stdenv, python3Packages, fetchFromGitHub, mopidy }:

python3Packages.buildPythonApplication rec {
  pname = "mopidy-youtube-music";
  version = "unstable-2020-07-18";

  src = fetchFromGitHub {
    owner = "natumbri";
    repo = "mopidy-youtube";
    rev = "56f8270fce4df4483c44c8a3fd31c5942f439bff";
    sha256 = "1civh3inn9d7849449lh9i169l7ba12ck0zgm51b2sbr42hk2g4w";
  };

  patchPhase = "sed s/bs4/beautifulsoup4/ -i setup.cfg";

  propagatedBuildInputs = [
    mopidy
    python3Packages.beautifulsoup4
    python3Packages.cachetools
    python3Packages.youtube-dl
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Mopidy extension for playing music from YouTube";
    license = licenses.asl20;
    maintainers = [ maintainers.spwhitt ];
  };
}
