{ stdenv, callPackage, fetchRepoProject, writeScript, bash, coreutils }:

{ version, sha256, ... } @ attrs:

let
  buildSdk = callPackage ./repo.nix {
    runScript = writeScript "build-android-sdk-${version}" ''
      #!${stdenv.shell}
      source build/envsetup.sh
      lunch sdk-eng
      make sdk
    '';
  };

in stdenv.mkDerivation rec {
  inherit version;
  pname = "android-sdk";
  name = "${pname}-${version}";

  src = fetchRepoProject rec {
    inherit sha256;
    name = "android-repo-${rev}";
    rev = "android-${version}";
    manifest = https://android.googlesource.com/platform/manifest;
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ buildSdk ];

  buildPhase = ''
    ${buildSdk}/bin/android-repo-env
  '';
}
