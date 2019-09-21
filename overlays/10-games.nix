self: super:
# let
  # secrets = import ../secrets.nix;
# in rec {
rec {
  # steam = super.steam.override { nativeOnly = true; };

  steamcmd = self.callPackage ../pkgs/steamcmd {
    steamRoot = "/home/tad/.local/share/Steam";
  };

  fetchsteam = self.callPackage ../pkgs/fetchsteam {
    inherit steamcmd;
  };

  enyo-doom = self.libsForQt5.callPackage ../pkgs/enyo-doom {};

  # quake-data = fetchsteam {
  #   name = "quake";
  #   appId = 2310;
  #   depotId = 2311;
  #   manifestId = 6053405624730600672;
  #   sha256 = "1bmpgqwcp7640dbq1w8bkbk6mkn4nj5yxkvmjrl5wnlg0m1g0jr7";
  #   inherit (secrets.steam) username password;
  # };

  vkquake = super.vkquake.overrideAttrs (oldAttrs: rec {
    buildFlags = [ "DO_USERDIRS=1" ];
  });

  inherit (self.callPackage ../pkgs/yquake2 {})
    yquake2
    yquake2-ctf
    yquake2-ground-zero
    yquake2-the-reckoning
    yquake2-all-games;
}
