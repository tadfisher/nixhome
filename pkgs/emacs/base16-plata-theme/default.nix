{ lib, trivialBuild, base16-theme }:

trivialBuild rec {
  pname = "base16-plata-theme";
  version = "0.1";

  src = ./.;

  packageRequires = [ base16-theme ];

  preBuild = ''
    export EMACSLOADPATH=${base16-theme}/share/emacs/site-lisp/elpa/${base16-theme.pname}-${base16-theme.version}:$EMACSLOADPATH
  '';

  meta = {
    description = "Plata themes for Emacs";
    license = lib.licenses.gpl3;
  };
}
