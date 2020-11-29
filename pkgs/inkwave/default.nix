{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "inkwave";
  version = "20180517";

  src = fetchFromGitHub {
    owner = "fread-ink";
    repo = pname;
    rev = "4123fb278f6f22300c463565b9333f87d4ae182a";
    sha256 = "1rr8rfw97nvhkgwnp8fhbpf62lyp14qg4fv4j9p453w3j2q74n10";
  };

  installPhase = ''
    mkdir -p $out/bin
    install -m 0755 inkwave $out/bin/inkwave
  '';
}
