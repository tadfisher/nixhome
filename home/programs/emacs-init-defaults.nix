{ pkgs, ... }:

{
  programs.emacs.init.usePackage = {
    plantuml-mode = {
      config = ''
        (setq plantuml-jar-path "${pkgs.plantuml}/lib/plantuml.jar")
      '';
    };

    ob-plantuml = {
      config = ''
        (setq org-plantuml-jar-path "${pkgs.plantuml}/lib/plantuml.jar")
      '';
    };

    ggtags = {
      config = ''
        (setq ggtags-executable-directory "${pkgs.global}/bin")
      '';
    };

    pandoc-mode = {
      config = ''
        (setq pandoc-binary "${pkgs.pandoc}/bin/pandoc")
      '';
    };

    ripgrep = {
      config = ''
        (setq ripgrep-executable "${pkgs.ripgrep}/bin/rg")
      '';
    };
  };
}
