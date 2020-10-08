{ stdenv, fetchFromGitHub, gnome3 }:

stdenv.mkDerivation rec {
  pname = "paperwm";
  version = "unstable-2020-08-23";

  uuid = "paperwm@hedning:matrix.org";

  src = fetchFromGitHub {
    owner = "paperwm";
    repo = "PaperWM";
    rev = "40a750918845f3c708dd1b51a40f2d29c48808c2";
    sha256 = "01r2ifwrl8w735d0ckzlwhvclax9dxd2ld5y2svv5bp444zbjsag";
  };

  buildPhase = ''
    base="$out/share/gnome-shell/extensions/${uuid}"
    schemas="$out/share/gsettings-schemas/${pname}-${version}/glib-2.0/schemas"
    mkdir -p "$base" "$schemas"
    cp -a * "$base"/
    ln -s "$base/schemas/{*.xml,gschemas.compiled}" "$schemas"
  '';

  meta = with stdenv.lib; {
    description = "Tiled scrollable window management for Gnome Shell";
    license = licenses.gpl3;
    maintainers = with maintainers; [ tadfisher ];
    homepage = "https://github.com/paperwm/PaperWM";
    platforms = gnome3.gnome-shell.meta.platforms;
  };
}
