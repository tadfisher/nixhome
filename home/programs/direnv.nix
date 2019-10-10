{ config, lib, pkgs, ... }:

let
  cfg = config.programs.direnv;

in

mkIf cfg.enable {
  programs.direnv.stdlib = ''
    use_nix() {
      local path="$(nix-instantiate --find-file nixpkgs)"

      if [ -f "${path}/.version-suffix" ]; then
        local version="$(< $path/.version-suffix)"
      elif [ -f "${path}/.git" ]; then
        local version="$(< $(< ${path}/.git/HEAD))"
      fi

      local cache=".direnv/cache-${version:-unknown}"

      local update_drv=0
      if [[ ! -e "$cache" ]] || \
        [[ "$HOME/.direnvrc" -nt "$cache" ]] || \
        [[ .envrc -nt "$cache" ]] || \
        [[ default.nix -nt "$cache" ]] || \
        [[ shell.nix -nt "$cache" ]];
      then
        [ -d .direnv ] || mkdir .direnv
        nix-shell --show-trace --pure "$@" --run "\"$direnv\" dump bash" > "$cache"
        update_drv=1
      else
        log_status using cached derivation
      fi
      local term_backup=$TERM path_backup=$PATH
      if [ -z ${TMPDIR+x} ]; then
        local tmp_backup=$TMPDIR
      fi

      if [ -z ${SSL_CERT_FILE+x} ]; then
        local ssl_cert_file_backup=$SSL_CERT_FILE
      fi
      if [ -z ${NIX_SSL_CERT_FILE+x} ]; then
        local nix_ssl_cert_file_backup=$NIX_SSL_CERT_FILE
      fi
      eval "$(< $cache)"
      export PATH=$PATH:$path_backup TERM=$term_backup TMPDIR=$tmp_backup
      if [ -z ${tmp_backup+x} ]; then
        export TMPDIR=${tmp_backup}
      else
        unset TMPDIR
      fi
      if [ -z ${ssl_cert_file_backup+x} ]; then
        export SSL_CERT_FILE=${ssl_cert_file_backup}
      else
        unset SSL_CERT_FILE
      fi
      if [ -z ${nix_ssl_cert_file_backup+x} ]; then
        export NIX_SSL_CERT_FILE=${nix_ssl_cert_file_backup}
      else
        unset NIX_SSL_CERT_FILE
      fi

      # This part is based on https://discourse.nixos.org/t/what-is-the-best-dev-workflow-around-nix-shell/418/4
      if [ "$out" ] && (( $update_drv )); then
        drv_link=".direnv/drv"
        drv="$(nix show-derivation $out | jq --raw-output 'keys | .[]')"
        ln -fs "$drv" "$drv_link"
        ln -fs "$PWD/$drv_link" "/nix/var/nix/gcroots/per-user/$LOGNAME/$(basename "$PWD")"
        log_status renewed cache and derivation link
      fi

      if [[ $# = 0 ]]; then
        watch_file default.nix
        watch_file shell.nix
      fi
    }
  '';
}