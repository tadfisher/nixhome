{ stdenv, fetchFromGitHub
, boost, coreutils, pkgconfig, python3, wrapGAppsHook
, cairomm, cppzmq, curl, epoxy, glib, glm, gtkmm3, libgit2, librsvg, libsigcxx, libyamlcpp, libzip
, opencascade_oce, podofo, sqlite, utillinux, zeromq
}:

stdenv.mkDerivation rec {
  pname = "horizon-eda";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = "horizon";
    rev = "v${version}";
    sha256 = "0b1bi99xdhbkb2vdb9y6kyqm0h8y0q168jf2xi8kd0z7kww8li2p";
  };

  nativeBuildInputs = [ boost coreutils pkgconfig python3 wrapGAppsHook ];

  buildInputs = [
    boost cairomm cppzmq curl epoxy glib glm gtkmm3 libgit2 librsvg libsigcxx libyamlcpp libzip
    opencascade_oce podofo sqlite utillinux zeromq
  ];

  buildFlags = [
    "CASROOT=${opencascade_oce}"
  ];

  installFlags = [
    "PREFIX=$(out)"
  ];

  enableParallelBuilding = true;

  preInstall = ''
    substituteInPlace Makefile \
      --replace /usr/bin/install ${coreutils}/bin/install
  '';

  meta = with stdenv.lib; {
    description = "Free Electronic Design Automation package";
    homepage = "https://horizon-eda.org";
    license = licenses.gpl3;
    maintainers = with maintainers; [ tadfisher ];
    platforms = platforms.linux;
  };
}
