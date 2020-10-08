{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libxml2 }:

stdenv.mkDerivation {
  pname = "hidrd";
  version = "unstable-2019-06-03";

  src = fetchFromGitHub {
    owner = "DIGImend";
    repo = "hidrd";
    rev = "6c0ed39708a5777ac620f902f39c8a0e03eefe4e";
    sha256 = "1rnhq6b0nrmphdig1qrpzpbpqlg3943gzpw0v7p5rwcdynb6bb94";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libxml2 ];

  meta = with stdenv.lib; {
    description = "HID report descriptor I/O library and conversion tool";
    homepage = "https://github.com/DIGImend/hidrd";
    license = licenses.gpl2;
    maintainers = [ maintainers.tadfisher ];
  };
}
