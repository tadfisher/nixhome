{ config, lib, pkgs, ... }:

let
  pass = config.programs.pass.stores.".local/share/pass/personal";

in {
  accounts.email = {
    maildirBasePath = "mail";

    accounts."tadfisher@gmail.com" = {
      address = "tadfisher@gmail.com";
      flavor = "gmail.com";
      gpg = {
        key = "tadfisher@gmail.com";
        signByDefault = true;
      };
      msmtp.enable = true;
      notmuch.enable = true;
      passwordCommand = "${pass.command} show mail.google.com/tadfisher@gmail.com";
      realName = "Tad Fisher";
      userName = "tadfisher@gmail.com";
    };
  };

  programs.notmuch = {
    enable = true;
    new = {
      ignore = [ ".*\.json" ];
    };
  };
}
