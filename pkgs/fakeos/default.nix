{ stdenv, meson, ninja, pkgconfig, libxdg_basedir }:

stdenv.mkDerivation {
  pname = "fakeos";
  version = "0.1";

  src = ./.;

  nativeBuildInputs = [ meson ninja pkgconfig ];

  buildInputs = [ libxdg_basedir ];

  meta = with stdenv.lib; {
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
