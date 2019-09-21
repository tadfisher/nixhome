self: super: with self; {
  lieer = super.gmailieer.overrideAttrs (attrs: rec {
    src = ~/src/lieer;
  });
}
