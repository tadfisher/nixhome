{ stdenv, rustPlatform, fetchFromGitHub, python3, xorg }:

rustPlatform.buildRustPackage rec {
  name = "inset-${version}";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "tadfisher";
    repo = "inset";
    rev = "v${version}";
    sha256 = "0rc51vvffahx4vxxls66scknxmw8pldbdmw3jqmrmw38j97ymfrw";
  };

  cargoSha256 = "0hnk3zniib6d3ixwwziknzaxis03bl51ickv3bvzccs4kq1rjgz7";

  buildInputs = [ python3 xorg.libxcb ];
}
