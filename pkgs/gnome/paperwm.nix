{ stdenv, fetchFromGitHub, gnome3 }:

stdenv.mkDerivation rec {
  pname = "paperwm";
  version = "unstable-2020-08-23";

  uuid = "paperwm@hedning:matrix.org";

  src = fetchFromGitHub {
    owner = "paperwm";
    repo = "PaperWM";
    rev = "ee0a3eaee414fc9e8e708ed961a0738f54eed023";
    sha256 = "1qy5zkl0ki71b19713ns8n8jvbg4bc0svppklc68wpm5pj6zcp90";
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
