[
  misc/gtk.nix
  misc/xdg.nix

  profiles/desktop.nix
  profiles/dev.nix
  profiles/games.nix
  profiles/gnome.nix
  profiles/nixos.nix

  programs/emacs.nix
  programs/git.nix
  programs/ssh.nix

  services/gpg-agent.nix
] ++ (if builtins.pathExists ../local.nix then [
  ../local.nix
] else [])
