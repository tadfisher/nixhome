{ lib, buildPythonPackage, fetchPypi, toPythonModule, pythonPackages
, mkdocs, htmlmin, jsmin }:

buildPythonPackage rec {
  pname = "mkdocs-minify-plugin";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dkln0s68ssxb0wpwqa9g546fb12l5ggvxxam1b2zx6hkl3aa01h";
  };

  propagatedBuildInputs = [
    mkdocs
    htmlmin
    jsmin
  ];

  meta = with lib; {
    description = "A mkdocs plugin to minify the HTML of a page before it is written to disk.";
    homepage = "https://github.com/byrnereese/mkdocs-minify-plugin";
    license = licenses.mit;
    maintainers = [ maintainers.tadfisher ];
  };
}
