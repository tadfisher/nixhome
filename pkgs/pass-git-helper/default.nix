{ lib, buildPythonApplication, fetchFromGitHub, pass, pyxdg }:

buildPythonApplication rec {
  pname = "pass-git-helper";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "languitar";
    repo = pname;
    rev = "v${version}";
    sha256 = "18nvwlp0w4aqj268wly60rnjzqw2d8jl0hbs6bkwp3hpzzz5g6yd";
  };

  propagatedBuildInputs = [ pass pyxdg ];

  doCheck = false;

  meta = with lib; {
    description = "Git credential helper for password-store (pass)";
    homepage = "https://github.com/languitar/pass-git-helper";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.tadfisher ];
  };
}
