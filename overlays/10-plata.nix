self: super: {
  plata-theme = super.plata-theme.overrideAttrs (attrs: rec {
    version = "0.8.8";
    src = attrs.src // {
      rev = version;
      sha256 = "1xb28s67lnsphj97r15jxlfgydyrxdby1d2z5y3g9wniw6z19i9n";
    };
  });
}
