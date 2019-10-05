{ stdenv, fetchFromGitHub, cmake, gedit, nautilus-python, gettext }:

stdenv.mkDerivation rec {
  pname = "nautilus-admin";
  version = "1.1.9";

  src = fetchFromGitHub {
    owner = "brunonova";
    repo = pname;
    rev = "v${version}";
    sha256 = "1127pgzkhwfdyp266vfsw949978w9190rwvqjr10345h45l8wlb4";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ gedit nautilus-python gettext ];

  meta = with stdenv.lib; {
    description = "Extension for Nautilus to do administrative operations";
    homepage = "https://github.com/brunonova/nautilus-admin";
    license = licenses.gpl3;
    maintainers = [ maintainers.tadfisher ];
  };
}
