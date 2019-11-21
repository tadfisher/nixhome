{ stdenv, fetchFromGitHub, gnome3 }:

stdenv.mkDerivation rec {
  pname = "paperwm";
  version = "unstable-2019-11-13";

  uuid = "paperwm@hedning:matrix.org";

  src = fetchFromGitHub {
    owner = "paperwm";
    repo = "PaperWM";
    rev = "b58050f7f5915634fe67faeec1dfa113f6df7d1c";
    sha256 = "1l8y79fdhp2d8pha73yaf385ag49hx1lvajq154fqx84ha361mpj";
  };

  buildPhase = ''
    base="$out/share/gnome-shell/extensions/${uuid}"
    schemas="$out/share/gsettings-schemas/${pname}-${version}/glib-2.0/schemas"
    mkdir -p "$base" "$schemas"
    cp -a * "$base"/
    mv "$base/schemas/{*.xml,gschemas.compiled}" "$schemas"
  '';

  meta = with stdenv.lib; {
    description = "Tiled scrollable window management for Gnome Shell";
    license = licenses.gpl3;
    maintainers = with maintainers; [ tadfisher ];
    homepage = "https://github.com/paperwm/PaperWM";
    platforms = gnome3.gnome-shell.meta.platforms;
  };
}
