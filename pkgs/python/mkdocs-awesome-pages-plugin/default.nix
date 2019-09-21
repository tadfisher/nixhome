{ lib, buildPythonPackage, fetchPypi, mkdocs }:

buildPythonPackage rec {
  pname = "mkdocs-awesome-pages-plugin";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18vmd4ya0y3yjqhyj5qv7l870y1643pq4lg702j3q1vfsg2ygc0c";
  };

  propagatedBuildInputs = [ mkdocs ];

  meta = with lib; {
    description = "MkDocs plugin that simplifies configuring page titles and their order";
    homepage = "https://github.com/lukasgeiter/mkdocs-awesome-pages-plugin/";
    license = licenses.mit;
    maintainers = [ maintainers.tadfisher ];
  };
}
