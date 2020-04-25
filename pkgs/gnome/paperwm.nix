{ stdenv, fetchFromGitHub, gnome3 }:

stdenv.mkDerivation rec {
  pname = "paperwm";
  version = "unstable-2020-03-02";

  uuid = "paperwm@hedning:matrix.org";

  src = fetchFromGitHub {
    owner = "paperwm";
    repo = "PaperWM";
    rev = "42a69e6c8b748723fcf06e0c4219b8fc2a40fc04";
    sha256 = "05k884k3c4vck4fvca3cx8hrrpkqdyc7hkyshq7pb560pdfklm97";
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
