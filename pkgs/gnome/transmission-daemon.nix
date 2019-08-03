{ stdenv, fetchFromGitHub, glib }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-transmission-daemon";
  version = "25";

  src = fetchFromGitHub {
    owner = "TheKevJames";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vrn8n5zywlrc5a47549wmvbnfib56wnamq3mp57ddj0rfama1zz";
  };

  uuid = "transmission-daemon@patapon.info";

  nativeBuildInputs = [ glib ];

  buildPhase = ''
    glib-compile-schemas ${uuid}/schemas
  '';

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions
    cp -r ${uuid} $out/share/gnome-shell/extensions
  '';
}
