{ lib, buildPythonPackage, fetchPypi , markdown, pep562 }:

buildPythonPackage rec {
  pname = "pymdown-extensions";
  version = "6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1sdww724ziyjdwkqvi6l8ixwslfqnd0a2yjiznfpbwcmm7g8c14n";
  };

  propagatedBuildInputs = [ markdown pep562 ];

  doCheck = false;

  meta = with lib; {
    description = "Extension pack for Python Markdown";
    homepage = "https://github.com/facelessuser/pymdown-extensions";
    license = licenses.mit;
    maintainers = [ maintainers.tadfisher ];
  };
}
