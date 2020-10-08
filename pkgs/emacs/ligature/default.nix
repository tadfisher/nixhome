{ stdenv, fetchFromGitHub, trivialBuild }:

trivialBuild {
  pname = "ligature";
  version = "unstable-2020-01-01";

  src = fetchFromGitHub {
    owner = "mickeynp";
    repo = "ligature.el";
    rev = "9aa31e7e31286e607c9d4f2d8a2855d4bbf9da9e";
    sha256 = "1lv8yxab5lcjk0m4f27p76hmp17yy9803zhvqpqgh46l05kahjvk";
  };

  meta = with stdenv.lib; {
    description = "Typographic ligatures in Emacs";
    homepage = "https://github.com/mickeynp/ligature.el";
    license = licenses.gpl3;
    maintainers = [ maintainers.tadfisher ];
  };
}
