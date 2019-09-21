{ python, mkdocs }:

let

  inherit (python.pkgs) callPackage toPythonModule;
  mkdocsApp = mkdocs;

in

rec {
  mkdocs = toPythonModule (mkdocsApp.override {
    inherit python;
  });

  mkdocs-awesome-pages-plugin = callPackage ./mkdocs-awesome-pages-plugin {
    inherit mkdocs;
  };

  mkdocs-material = callPackage ./mkdocs-material {
    inherit mkdocs mkdocs-minify-plugin pymdown-extensions;
  };

  mkdocs-minify-plugin = callPackage ./mkdocs-minify-plugin {
    inherit mkdocs;
  };

  pep562 = callPackage ./pep562 {};

  pymdown-extensions = callPackage ./pymdown-extensions {
    inherit pep562;
  };
}
