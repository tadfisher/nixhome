{ lib, buildPythonPackage, fetchPypi, toPythonModule, pythonPackages
, mkdocs, mkdocs-minify-plugin, pygments, pymdown-extensions }:

buildPythonPackage rec {
  pname = "mkdocs-material";
  version = "4.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ch70hkv95c0sr2578qx7wfvl7hb1q5dzqfxxc9y2z126kv43rnk";
  };

  propagatedBuildInputs = [
    mkdocs
    mkdocs-minify-plugin
    pygments
    pymdown-extensions
  ];

  meta = with lib; {
    description = "Material theme for MkDocs static site generator";
    homepage = "https://squidfunk.github.io/mkdocs-material/";
    license = licenses.mit;
    maintainers = [ maintainers.tadfisher ];
  };
}
