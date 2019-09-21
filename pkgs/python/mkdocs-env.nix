{ python }:

python.buildEnv.override {
  extraLibs = with python.pkgs; [
    mkdocs
    mkdocs-awesome-pages-plugin
    mkdocs-material
    pip
    pygments
    pymdown-extensions
  ];
  ignoreCollisions = true;
}
