{ stdenv
, fetchurl
, fetchpatch
, pkgconfig
, gettext
, docbook_xsl
, docbook_xml_dtd_43
, gtk-doc
, meson
, ninja
, python3
, makeWrapper
, shaderc
, libxslt
, shared-mime-info
, isocodes
, expat
, glib
, cairo
, pango
, gdk-pixbuf
, atk
, at-spi2-atk
, colord
, dconf
, gobject-introspection
, gst-plugins-bad
, gst-plugins-base
, gstreamer
, fribidi
, xorg
, epoxy
, json-glib
, libxkbcommon
, gmp
, gnome3
, graphene
, gsettings-desktop-schemas
, sassc
, vulkan-loader
, x11Support ? stdenv.isLinux
, waylandSupport ? stdenv.isLinux
, mesa
, vulkan-headers
, wayland
, wayland-protocols
, xineramaSupport ? stdenv.isLinux
, cupsSupport ? stdenv.isLinux
, withGtkDoc ? stdenv.isLinux
, cups ? null
, AppKit
, Cocoa
}:

assert cupsSupport -> cups != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "gtk4";
  version = "3.98.3";

  outputs = [ "out" "dev" ] ++ optional withGtkDoc "devdoc";
  outputBin = "dev";

  setupHooks = [
    ./hooks/gtk4-clean-immodules-cache.sh
    ./hooks/drop-icon-theme-cache.sh
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gtk/${stdenv.lib.versions.majorMinor version}/gtk-${version}.tar.xz";
    sha256 = "1zmq69ynvc3300n7sljm9qbyh7023ydsllsqjhsvhpvvab4fkmr5";
  };

  separateDebugInfo = stdenv.isLinux;

  mesonFlags = [
    "-Dcolord=yes"
    "-Dvulkan=yes"
    "-Dgtk_doc=${boolToString withGtkDoc}"
    "-Dtests=false"
  ];

  # These are the defines that'd you'd get with --enable-debug=minimum (default).
  # See: https://developer.gnome.org/gtk3/stable/gtk-building.html#extra-configuration-options
  NIX_CFLAGS_COMPILE = "-DG_ENABLE_DEBUG -DG_DISABLE_CAST_CHECKS";

  postPatch = ''
    files=(
      build-aux/meson/post-install.py
      demos/gtk-demo/geninclude.py
      gdk/broadway/gen-c-array.py
      gdk/gen-gdk-gresources-xml.py
      gtk/gen-gtk-gresources-xml.py
      gtk/gentypefuncs.py
    )

    chmod +x ''${files[@]}
    patchShebangs ''${files[@]}

    sed -i "s|gtk4-update-icon-cache|$dev/bin/gtk4-update-icon-cache|g" build-aux/meson/post-install.py
  '';

  nativeBuildInputs = [
    gettext
    gobject-introspection
    makeWrapper
    meson
    ninja
    pkgconfig
    python3
    sassc
    shaderc
  ] ++ setupHooks ++ optionals withGtkDoc [
    docbook_xml_dtd_43
    docbook_xsl
    gtk-doc
    libxslt
  ];

  buildInputs = [
    libxkbcommon
    epoxy
    json-glib
    isocodes
  ]
  ++ optional stdenv.isDarwin AppKit
  ;

  propagatedNativeBuildInputs = [
    vulkan-headers
  ];

  propagatedBuildInputs = with xorg; [
    at-spi2-atk
    atk
    cairo
    colord
    dconf
    expat
    fribidi
    gdk-pixbuf
    glib
    graphene
    gsettings-desktop-schemas
    gst-plugins-bad
    gst-plugins-base
    gstreamer
    libICE
    libSM
    libXcomposite
    libXcursor
    libXi
    libXrandr
    libXrender
    pango
    vulkan-loader
  ]
  ++ optional stdenv.isDarwin Cocoa  # explicitly propagated, always needed
  ++ optionals waylandSupport [ mesa wayland wayland-protocols ]
  ++ optional xineramaSupport libXinerama
  ++ optional cupsSupport cups
  ;
  #TODO: colord?

  doCheck = false; # needs X11

  postInstall = optionalString (!stdenv.isDarwin) ''
    # The updater is needed for nixos env and it's tiny.
    moveToOutput bin/gtk4-update-icon-cache "$out"
    # Launcher
    moveToOutput bin/gtk4-launch "$out"

    # TODO: patch glib directly
    for f in $dev/bin/gtk4-encode-symbolic-svg; do
      wrapProgram $f --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    done
  '';

  # Wrap demos
  postFixup =  optionalString (!stdenv.isDarwin) ''
    demos=(gtk4-builder-tool gtk4-demo gtk4-demo-application gtk4-icon-browser gtk4-query-settings gtk4-widget-factory)

    for program in ''${demos[@]}; do
      wrapProgram $dev/bin/$program \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:$out/share/gsettings-schemas/${pname}-${version}"
    done
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gtk";
      attrPath = "gtk4";
    };
  };

  meta = {
    description = "A multi-platform toolkit for creating graphical user interfaces";
    longDescription = ''
      GTK is a highly usable, feature rich toolkit for creating
      graphical user interfaces which boasts cross platform
      compatibility and an easy to use API.  GTK it is written in C,
      but has bindings to many other popular programming languages
      such as C++, Python and C# among others.  GTK is licensed
      under the GNU LGPL 2.1 allowing development of both free and
      proprietary software with GTK without any license fees or
      royalties.
    '';
    homepage = https://www.gtk.org/;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ raskin vcunat lethalman worldofpeace ];
    platforms = platforms.all;
  };
}
