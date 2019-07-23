{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "corefreq-${version}";
  version = "20190324";

  src = fetchFromGitHub {
    owner = "cyring";
    repo = "CoreFreq";
    rev = "1667d8a5f0675799582ac6c9d2d080aeae0bdcee";
    sha256 = "1zicq0a7mnnglyiz7lv9qx1kfqwyhsrqyf2z48w8gypi06ifqk5g";
  };

  meta = with stdenv.lib; {
    description = "Processor monitoring software with a kernel module inside";
    platforms = [ platforms.linux ];
    license = licenses.gpl2;
    maintainers = [ maintainers.tadfisher ];
  };
}
