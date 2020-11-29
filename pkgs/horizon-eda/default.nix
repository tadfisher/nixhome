{ stdenv, fetchFromGitHub
, boost, coreutils, pkgconfig, python3, wrapGAppsHook
, cairomm, cppzmq, curl, epoxy, glib, glm, gtkmm3, libgit2, librsvg, libsigcxx, libyamlcpp, libzip
, opencascade_oce, podofo, sqlite, utillinux, zeromq
}:

stdenv.mkDerivation rec {
  pname = "horizon-eda";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = "horizon";
    rev = "v${version}";
    sha256 = "13c4p60vrmwmnrv2jcr2gc1cxnimy7j8yp1p6434pbbk2py9k8mx";
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
