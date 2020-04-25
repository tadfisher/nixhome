{ stdenv, fetchFromGitHub, buildPythonPackage }:

buildPythonPackage rec {
  pname = "pykka";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "jodal";
    repo = pname;
    rev = "v${version}";
    sha256 = "011rvv3vzj9rpwaq6vfpz9hfwm6gx1jmad4iri6z12g8nnlpydhs";
  };

  # Cannot import eventlet due to:
  # socket.getprotobyname('tcp')
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://www.pykka.org;
    description = "A Python implementation of the actor model";
    license = licenses.asl20;
    maintainers = [];
  };

}
