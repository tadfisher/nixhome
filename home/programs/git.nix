{ config, lib, pkgs, ... }:

with lib;

let
  secrets = config.passthru.secrets;

in

mkIf config.programs.git.enable {
  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    userName = "Tad Fisher";
    userEmail = "tadfisher@gmail.com";
    ignores = [ "*~" "#*#" ];
    signing = {
      key = "tadfisher@gmail.com";
      signByDefault = true;
    };
    delta = {
      enable = true;
      options = {
        features = "decorations";
      };
    };
    extraConfig = {
      branch = {
        autoSetupMerge = "true";
        autoSetupRebase = "remote";
      };
      http.cookiefile = "${config.xdg.configHome}/git/cookies";
      github.user = "tadfisher";
    };
  };

  xdg.configFile."git/cookies".text =
    let
      username = secrets.googlesource.username;
      password = secrets.googlesource.password;
    in ''
      android.googlesource.com	FALSE	/	TRUE	2147483647	o	${username}=${password}
      android-review.googlesource.com	FALSE	/	TRUE	2147483647	o	${username}=${password}
    '';
}
