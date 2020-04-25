{ stdenv, fetchgit, pkgconfig, wrapGAppsHook, cmake
, aspell
, boehmgc
, boost
, double_conversion
, fontconfig
, gdl
, gettext
, glib
, gsl
, gtkmm3
, gtkspell3
, harfbuzz
, imagemagick
, lcms2
, libcdr
, libjpeg
, libpng
, librevenge
, libsigcxx
, libsoup
, libvisio
, libwpg
, libxml2
, libxslt
, openmp
, pangomm
, pcre
, perl
, poppler
, potrace
, python3
, ruby
, zlib

# , perlPackages, libXft
# , libpng, zlib, popt, boehmgc, libxml2, libxslt, glib, gtkmm2
# , glibmm, libsigcxx, lcms, boost, gettext, makeWrapper
# , gsl, gtkspell2, cairo, python3, poppler, imagemagick, libwpg, librevenge
# , libvisio, libcdr, libexif, potrace, cmake
# , librsvg, wrapGAppsHook
}:

let
  python3Env = python3.withPackages(ps: with ps;
    [ numpy lxml scour ]);
in

stdenv.mkDerivation rec {
  name = "inkscape-1.0-beta2";

  src = fetchgit {
    url = "https://gitlab.com/inkscape/inkscape.git";
    rev = "INKSCAPE_1_0_BETA_2";
    sha256 = "1kfgwqlbgy2x788d5lf19bvbrf111n01lbzflhx6175s79bi8q27";
  };

  postPatch = ''
    patchShebangs share/extensions
    patchShebangs man/fix-roff-punct

    # Python is used at run-time to execute scripts, e.g., those from
    # the "Effects" menu.
    substituteInPlace src/extension/implementation/script.cpp \
      --replace '"python-interpreter", "python"' '"python-interpreter", "${python3Env}/bin/python"' \
      --replace '"perl-interpreter", "perl"' '"perl-interpreter", "${perl}/bin/perl"' \
      --replace '"ruby-interpreter", "ruby"' '"ruby-interpreter", "${ruby}/bin/ruby"' \
      --replace '"shell-interpreter", "sh"' '"shell-interpreter", "${stdenv.shell}/bin/sh"'
  '';

  nativeBuildInputs = [
    pkgconfig cmake python3Env wrapGAppsHook
  ];
#    ++ (with perlPackages; [ perl XMLParser ]);
  buildInputs = [
    aspell
    boehmgc
    boost
    double_conversion
    fontconfig
    gdl
    gettext
    glib
    gsl
    gtkmm3
    gtkspell3
    harfbuzz
    imagemagick
    lcms2
    libcdr
    libjpeg
    libpng
    librevenge
    libsigcxx
    libsoup
    libvisio
    libwpg
    libxml2
    libxslt
    openmp
    pangomm
    pcre
    perl
    poppler
    potrace
    python3Env
    ruby
    zlib

    # libpng zlib popt boehmgc
    # libxml2 libxslt glib gtkmm2 glibmm libsigcxx lcms boost gettext
    # gsl poppler imagemagick libwpg librevenge
    # libvisio libcdr libexif potrace

    # librsvg # for loading icons

    # python2Env perlPackages.perl
  ] ++ stdenv.lib.optional (!stdenv.isDarwin) gtkspell3;
#    ++ stdenv.lib.optional stdenv.isDarwin cairo;

  enableParallelBuilding = true;

  # Make sure PyXML modules can be found at run-time.
  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -change $out/lib/libinkscape_base.dylib $out/lib/inkscape/libinkscape_base.dylib $out/bin/inkscape
    install_name_tool -change $out/lib/libinkscape_base.dylib $out/lib/inkscape/libinkscape_base.dylib $out/bin/inkview
  '';

  meta = with stdenv.lib; {
    license = "GPL";
    homepage = https://www.inkscape.org;
    description = "Vector graphics editor";
    platforms = platforms.all;
    longDescription = ''
      Inkscape is a feature-rich vector graphics editor that edits
      files in the W3C SVG (Scalable Vector Graphics) file format.

      If you want to import .eps files install ps2edit.
    '';
  };
}
