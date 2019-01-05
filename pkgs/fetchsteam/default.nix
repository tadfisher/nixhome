{ stdenv, runCommand, steamcmd }:

{ name, appId, depotId, manifestId, branch ? null, sha256
, username ? "anonymous", password ? "", steamGuardCode ? (builtins.getEnv "NIX_STEAM_GUARD_CODE")
, fileList ? [] }:

with stdenv.lib;

runCommand "${name}-src" {
  buildInputs = [ steamcmd ];
  inherit username password appId depotId manifestId;
  outputHashAlgo = "sha256";
  outputHash = sha256;
  outputHashMode = "recursive";
} ''
  steamcmd \
    +@ShutdownOnFailedCommand 1 \
    +@NoPromptForPassword 1 \
    ${optionalString (steamGuardCode != "") "+set_steam_guard_code ${steamGuardCode}"} \
    "+login ${username} ${password}" \
    +force_install_dir $out \
    "+download_depot ${toString appId} ${toString depotId} ${toString manifestId}" \
    +quit
''
