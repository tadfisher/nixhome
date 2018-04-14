{ stdenv, fetchgit, makeWrapper, gnum4, coreutils, pacman, utillinux }:

stdenv.mkDerivation rec {
  name = "arch-install-scripts-${version}";
  version = "18";

  src = fetchgit {
    url = "git://git.archlinux.org/arch-install-scripts.git";
    rev = "v18";
    sha256 = "0qjb7l4s41x9lslhsllp6gsisbl93qfvpv741kc2flj4ma30qxba";
  };

  nativeBuildInputs = [ gnum4 ];

  buildInputs = [ makeWrapper coreutils pacman utillinux ];

  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = true;

  postInstall = ''
    for file in $out/bin/*; do
      wrapProgram $file --prefix PATH : ${stdenv.lib.makeBinPath [ coreutils pacman utillinux ]}
    done
  '';

  meta = with stdenv.lib; {
    description = "Scripts to aid in installing Arch Linux";
    homepage = "https://projects.archlinux.org/arch-install-scripts.git";
    license = licenses.gpl2;
    maintainers = with maintainers; [ tadfisher ];
    platforms = platforms.linux;
  };
}
