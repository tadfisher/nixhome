{ callPackage
, buildFHSUserEnv
, fetchRepoProject
, jdk
, runScript
}:

buildFHSUserEnv {
  name = "android-repo-env";
  targetPkgs = pkgs: with pkgs; [
    bash-completion
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
    jdk
    libxml2
    lzop
    m4
    ncurses5
    nettools
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
  multiPkgs = pkgs: with pkgs; [ zlib ];
  extraOutputsToInstall = [ "dev" ];
  inherit runScript;
  profile = ''
    export ANDROID_JAVA_HOME=${jdk.home}
    export LANG=C
    unset _JAVA_OPTIONS
    export BUILD_NUMBER=$(date --utc +%Y.%m.%d.%H.%M.%S)
    export DISPLAY_BUILD_NUMBER=true
  '';
}
