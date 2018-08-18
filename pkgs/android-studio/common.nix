{ pname, channel, version, build, sha256Hash, meta }:
{ bash
, buildEnv
, buildFHSUserEnv
, coreutils
, fetchurl
, findutils
, file
, fontsConf
, git
, glxinfo
, gnugrep
, gnused
, gnutar
, gtk2, gnome_vfs, glib, GConf
, gzip
, fontconfig
, freetype
, libpulseaudio
, libX11
, libXext
, libXi
, libXrandr
, libXrender
, libXtst
, makeDesktopItem
, makeWrapper
, pciutils
, pkgsi686Linux
, setxkbmap
, stdenv
, unzip
, which
, writeScript
, xkeyboard_config
, zlib
}:

let
  channelCap = with stdenv.lib; (toUpper (substring 0 1 channel)) + substring 1 (-1) channel;

  androidStudio = stdenv.mkDerivation {
    name = "${pname}-${version}";

    src = fetchurl {
      url = "https://dl.google.com/dl/android/studio/ide-zips/${version}/android-studio-ide-${build}-linux.zip";
      sha256 = sha256Hash;
    };

    buildInputs = [
      makeWrapper
      unzip
    ];

    postPatch = ''
      mkdir -p idea
      unzip -p lib/resources.jar idea/AndroidStudioApplicationInfo.xml \
        | sed 's/"Studio"/"Studio ${channelCap}"' >idea/AndroidStudioApplicationInfo.xml
      zip -r lib/resources.jar idea
      rm -r idea
    '';

    installPhase = ''
      cp -r . $out
      wrapProgram $out/bin/studio.sh \
        --set ANDROID_EMULATOR_USE_SYSTEM_LIBS 1 \
        --set PATH "${stdenv.lib.makeBinPath [

          # Checked in studio.sh
          coreutils
          findutils
          gnugrep
          which
          gnused

          # For Android emulator
          file
          glxinfo
          pciutils
          setxkbmap

          # Used during setup wizard
          gnutar
          gzip

          # Runtime stuff
          git
        ]}" \
        --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [

          # Crash at startup without these
          fontconfig
          freetype
          libXext
          libXi
          libXrender
          libXtst

          # Gradle wants libstdc++.so.6
          stdenv.cc.cc.lib
          # mksdcard wants 32 bit libstdc++.so.6
          pkgsi686Linux.stdenv.cc.cc.lib

          # aapt wants libz.so.1
          zlib
          pkgsi686Linux.zlib
          # Support multiple monitors
          libXrandr

          # For Android emulator
          libpulseaudio
          libX11

          # For GTKLookAndFeel
          gtk2
          gnome_vfs
          glib
          GConf
        ]}" \
        --set QT_XKB_CONFIG_ROOT "${xkeyboard_config}/share/X11/xkb" \
        --set FONTCONFIG_FILE ${fontsConf}
    '';
  };

  # Android Studio downloads prebuilt binaries as part of the SDK. These tools
  # (e.g. `mksdcard`) have `/lib/ld-linux.so.2` set as the interpreter. An FHS
  # environment is used as a work around for that.
  fhsEnv = buildFHSUserEnv {
    name = "${pname}-fhs-env";
    multiPkgs = pkgs: [ pkgs.ncurses5 ];
  };

  wrapper = writeScript "${pname}-${version}" {
    destination = "/bin/${pname}";
    text = ''
      #!${bash}/bin/bash
      ${fhsEnv}/bin/${pname}-fhs-env ${androidStudio}/bin/studio.sh $@
    '';
  };

  desktopItem = makeDesktopItem {
    name = "android-studio-${version}";
    exec = "$out/bin/android-studio %f";
    icon = "android-studio";
    comment = meta.description;
    desktopName = "Android Studio (${channelCap})";
    genericName = "Android IDE";
    mimeType = "application/x-extension-iml";
    categories = "Development;IDE;";
    startupNotify = "true";
    extraEntries = "StartupWMClass=jetbrains-studio-${channel}";
  };

in
  buildEnv {
    name = "${pname}-env";
    paths = [ wrapper desktopItem ];
  } // { inherit meta; }
