{ stdenv, fetchFromGitHub, glib, gup }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-scroll-workspaces";
  version = "unstable-2018-09-18";

  src = fetchFromGitHub {
    owner = "timbertson";
    repo = pname;
    rev = "733f41f572cdd04ac478d80b3ab5b0f766470cc7";
    sha256 = "1b16vxm8c0c7av4gm8mdxdd4xsbglhaf91dz4ndk2ghnnbw0zb26";
  };

  uuid = "scroll-workspaces@gfxmonk.net";

  nativeBuildInputs = [ glib gup ];

  buildPhase = ''
    gup
    gup --clean -f --metadata scroll-workspaces
  '';

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions
    cp -r scroll-workspaces $out/share/gnome-shell/extensions/${uuid}
  '';
}
