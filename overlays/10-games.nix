self: super: {
  enyo-doom = self.libsForQt5.callPackage ../pkgs/enyo-doom {};

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
