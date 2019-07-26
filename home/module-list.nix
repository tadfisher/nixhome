[
  misc/gtk.nix
  misc/xdg.nix

  profiles/desktop.nix
  profiles/dev.nix
  profiles/electronics.nix
  profiles/exwm.nix
  profiles/games.nix
  profiles/gnome.nix
  profiles/nixos.nix
  profiles/work.nix

  programs/chromium.nix
  programs/emacs.nix
  programs/emacs-init.nix
  programs/git.nix
  programs/ssh.nix

  services/emacs.nix
  services/gpg-agent.nix
  services/inset.nix
  services/keybase.nix
  services/steam-controller.nix
] ++ (if builtins.pathExists ../local.nix then [
  ../local.nix
] else [])
