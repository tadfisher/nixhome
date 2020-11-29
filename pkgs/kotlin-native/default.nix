{ stdenv, fetchurl, autoPatchelfHook
, libclang, zlib }:

stdenv.mkDerivation rec {
  pname = "kotlin-native";
  version = "1.4.10";

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [ stdenv.cc.cc.lib libclang zlib ];

  src = fetchurl {
    url = "https://github.com/JetBrains/kotlin/releases/download/v${version}/kotlin-native-linux-${version}.tar.gz";
    sha256 = "0g1pka73nq3682afrhb19gs1xmif9p2hbrzackqczfdcrx3x1vfs";
  };

  installPhase = ''
    mkdir -p $out/{share/kotlin-native,bin}

    mv * $out/share/kotlin-native
    ln -s $out/share/kotlin-native/bin/* $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Compile Kotlin code to native binaries";
    homepage = "https://kotlinlang.org/docs/reference/native-overview.html";
    platform = platforms.linux;
    maintainers = with maintainers; [ tadfisher ];
    license = with licenses; [ asl20 ];
  };
}
