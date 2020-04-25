{ stdenv, rustPlatform, fetchFromGitHub, cargo }:

rustPlatform.buildRustPackage rec {
  pname = "rust-analyzer";
  version = "unstable-2020-02-28";

  src = fetchFromGitHub {
    owner = "rust-analyzer";
    repo = "rust-analyzer";
    rev = "d2bf2adc272197eafa56f77363edaa6c410b39cf";
    sha256 = "0aan927z47v13dpr93i58sgkndb57a6p4bbpyg3ppx3b63661bdz";
  };
  cargoBuildFlags = [
    "--package" "rust-analyzer"
    "--bin" "rust-analyzer"
  ];

  buildInputs = [
    rustPlatform.rustcSrc
  ];

  RUST_SRC_PATH = rustPlatform.rustcSrc;

  cargoSha256 = "0lqvkakhjjfr9zq1c68scfpxj4713mwxvx0gdspp8n58gw0ajvg6";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Modular compiler frontend for the Rust language";
    homepage = "https://github.com/rust-analyzer/rust-analyzer";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ tadfisher ];
  };
}
