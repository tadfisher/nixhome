[
  misc/gtk.nix
  misc/xdg.nix

  profiles/desktop.nix
  profiles/dev.nix
  profiles/exwm.nix
  profiles/games.nix
  profiles/gnome.nix
  profiles/nixos.nix

  programs/chromium.nix
  programs/emacs.nix
  programs/git.nix
  programs/ssh.nix

  services/gpg-agent.nix
  services/inset.nix
  services/keybase.nix
  services/steam-controller.nix
] ++ (if builtins.pathExists ../local.nix then [
  ../local.nix
] else [])
