{ stdenv, fetchFromGitHub, cmake, SDL2 }:

stdenv.mkDerivation rec {
  pname = "FAudio";
  version = "19.09";

  src = fetchFromGitHub {
    owner = "FNA-XNA";
    repo = pname;
    rev = version;
    sha256 = "0fagik55jmy3qmb27nhg0zxash1ahfkxphx8m8gs0pimqqrdrd9d";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ SDL2 ];

  meta = with stdenv.lib; {
    description = "Accuracy-focused XAudio reimplementation for open platforms";
    homepage = "https://fna-xna.github.io/";
    maintainers = [ maintainers.tadfisher ];
    license = licenses.zlib;
  };
}
