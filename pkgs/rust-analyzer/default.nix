{ stdenv, rustPlatform, fetchFromGitHub, cargo }:

rustPlatform.buildRustPackage rec {
  pname = "rust-analyzer";
  version = "unstable-2019-08-08";

  src = fetchFromGitHub {
    owner = "rust-analyzer";
    repo = "rust-analyzer";
    rev = "87608904f697a3f58ddb71a7f6828dac80f8b3ce";
    sha256 = "17jgacfzc4lw2rrcixahpj4cdd3q8mq208h9nxs8y9vqw685f7xs";
  };
  cargoBuildFlags = [ "--features" "jemalloc" "-p" "ra_lsp_server" ];

  buildInputs = [
    rustPlatform.rustcSrc
  ];

  RUST_SRC_PATH = rustPlatform.rustcSrc;

  cargoSha256 = "1919qa4mhwskbj82qxszi4ba48x3xp019bx466h2rflwmznwgg3i";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Modular compiler frontend for the Rust language";
    homepage = "https://github.com/rust-analyzer/rust-analyzer";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ tadfisher ];
  };
}
