{ callPackage
, buildFHSUserEnv
, fetchRepoProject

, bc
, binutils
, bison
, ccache
, coreutils
, curl
, flex
, gcc
, gdb
, gnumake
, gperf
, jdk
, libxml2
, lzop
, m4
, ncurses5
, nettools
, openjdk8
, openssl
, perl
, procps
, python2
, rsync
, schedtool
, unzip
, utillinux
, which
, zip
}:

{ rev, version, sha256, ... } @ attrs:

let
  fhs = buildFHSUserEnv {
    name = "android-env";
    targetPkgs = [
      bc
      binutils
      bison
      ccache
      coreutils
      curl
      flex
      gcc
      gdb
      gnumake
      gperf
      libxml2
      lzop
      m4
      ncurses5
      nettools
      openjdk8
      openssl
      perl
      procps
      python2
      rsync
      schedtool
      unzip
      utillinux
      which
      zip
    ];
    multiPkgs = [ zlib ];
    extraOuputsToInstall = [ "dev" ];
    runScript = "bash";
    profile = ''
      export USE_CCACHE=1
      export ANDROID_JAVA_HOME=${openjdk8.home}
      export LANG=C
      unset _JAVA_OPTIONS
      export BUILD_NUMBER=$(date --utc +%Y.%m.%d.%H.%M.%S)
      export DISPLAY_BUILD_NUMBER=true
    '';
  };
  repo = fetchRepoProject {
    inherit rev sha256;
    name = "android-repo-${rev}";
    manifest = https://android.googlesource.com/platform/manifest;
  };
in fhs.env
