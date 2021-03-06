[
  misc/gnome-paths.nix
  misc/gtk.nix
  misc/mail.nix

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
  programs/emacs.nix
  programs/firefox.nix
  programs/git.nix
  programs/gnome-terminal.nix
  programs/pass.nix
  programs/slack.nix
  programs/ssh.nix
  programs/texlive.nix
  programs/zoom-us.nix

  services/emacs.nix
  services/gpg-agent.nix
  services/inset.nix
  services/keybase.nix
  services/mopidy.nix
  services/steam-controller.nix
] ++ (if builtins.pathExists ../local.nix then [
  ../local.nix
] else [])
