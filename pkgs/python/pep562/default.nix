{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pep562";
  version = "1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15cknx9qznphl6z1964ii792dm8qfqsm0nlhnii3xnb3xv4irjsq";
  };

  doCheck = false;

  meta = with lib; {
    description = "Backport of PEP 562";
    homepage = "https://github.com/facelessuser/pep562";
    license = licenses.mit;
    maintainers = [ maintainers.tadfisher ];
  };
}
