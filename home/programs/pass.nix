{ config, lib, pkgs, ... }:

with lib;

{
  programs.pass = {
    package = pkgs.pass.withExtensions (e: [ e.pass-audit e.pass-otp ]);
    stores.".local/share/pass/personal".alias = "pp";
  };
}
