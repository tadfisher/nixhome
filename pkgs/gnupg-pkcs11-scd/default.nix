{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, pkcs11helper, libgpgerror, libassuan, libgcrypt
, sslBackend ? gnutls, openssl, gnutls
}:

assert sslBackend == gnutls || sslBackend == openssl;

stdenv.mkDerivation rec {
  pname = "gnupg-pkcs11-scd";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "alonbl";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "15pj9fkwq29g7z00hjyccrmyyz83amf0xiw6dfw87i2a6zsdr2bh";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
  ];

  buildInputs = [
    pkcs11helper
    libassuan
    libgcrypt
    libgpgerror
    sslBackend
  ];

  configureFlags = [
    "--with-libgpg-error-prefix=${libgpgerror.dev}"
    "--with-libassuan-prefix=${libassuan.dev}"
    "--with-libgcrypt-prefix=${libgcrypt.dev}"
  ];

  meta = with stdenv.lib; {
    description = "Smartcard daemon for PKCS#11 tokens with GnuPG";
    license = licenses.bsd3;
    maintainers = with maintainers; [ tadfisher ];
    platforms = platforms.unix;
  };
}
