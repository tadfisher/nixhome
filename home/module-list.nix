[
  misc/gtk.nix
  misc/mail.nix
  misc/xdg.nix

  profiles/desktop.nix
  profiles/dev.nix
  profiles/electronics.nix
  profiles/exwm.nix
  profiles/games.nix
  profiles/gnome.nix
  profiles/nixos.nix
  profiles/work.nix

  programs/bash.nix
  programs/chromium.nix
  programs/direnv.nix
  programs/emacs.nix
  programs/emacs-init.nix
  programs/firefox.nix
  programs/git.nix
  programs/gnome-terminal.nix
  programs/pass.nix
  programs/ssh.nix
  programs/zoom-us.nix

  services/emacs.nix
  services/gpg-agent.nix
  services/inset.nix
  services/keybase.nix
  services/steam-controller.nix
] ++ (if builtins.pathExists ../local.nix then [
  ../local.nix
] else [])
