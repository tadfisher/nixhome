{ stdenv, fetchFromGitHub, glib, lm_sensors, nvme-cli, udisks2 }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-freon";
  version = "38";

  src = fetchFromGitHub {
    owner = "UshakovVasilii";
    repo = pname;
    rev = "0d411fab7368c3910c6faffc0a28e05a1ff9c17c";
    sha256 = "07nbjhns6v7jvla7mkkgik98yibpf8wx0555s4w19fxi14d4nl95";
  };

  uuid = "freon@UshakovVasilii_Github.yahoo.com";

  nativeBuildInputs = [ glib ];

  propagatedBuildInputs = [
    lm_sensors
    nvme-cli
    udisks2
  ];

  buildPhase = ''
    glib-compile-schemas --strict --targetdir=${uuid}/schemas/ ${uuid}/schemas
  '';

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions
    cp -r ${uuid} $out/share/gnome-shell/extensions
  '';

  meta = with stdenv.lib; {
    description = "Show temperatures in GNOME Shell";
    license = licenses.gpl2;
    maintainers = with maintainers; [ tadfisher ];
    homepage = https://github.com/UshakovVasilii/gnome-shell-extension-freon;
  };
}
