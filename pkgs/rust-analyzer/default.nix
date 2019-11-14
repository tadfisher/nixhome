{ stdenv, rustPlatform, fetchFromGitHub, cargo }:

rustPlatform.buildRustPackage rec {
  pname = "rust-analyzer";
  version = "unstable-2019-08-08";

  src = fetchFromGitHub {
    owner = "rust-analyzer";
    repo = "rust-analyzer";
    rev = "5451bfb9a1c6482822bdd7883434b9230affd2ea";
    sha256 = "01ygfknqlya5pv6mrbfsdflj7qvsvgpl6p9p0lqbcp9p8hilqlq0";
  };
  cargoBuildFlags = [ "--features" "jemalloc" "-p" "ra_lsp_server" ];

  buildInputs = [
    rustPlatform.rustcSrc
  ];

  RUST_SRC_PATH = rustPlatform.rustcSrc;

  cargoSha256 = "1sryylax0y2sq70a6wcf5vmz3gfxsdiv9r6zdi7jv5zvdxsrqvxc";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Modular compiler frontend for the Rust language";
    homepage = "https://github.com/rust-analyzer/rust-analyzer";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ tadfisher ];
  };
}
