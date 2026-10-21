{
  lib,
  stdenvNoCC,
  fetchurl,
}:

let
  rev = "9d8b51d2e89fcf4d71f4d31e346a2b0ee4350716";

  regular = fetchurl {
    url = "https://raw.githubusercontent.com/xeji01/nothingfont/${rev}/fonts/Ndot57-Regular.otf";
    hash = "sha256-j5mpkdLKsQEOr3lSCnupuxfSh7R1e6ma6f+ZxNtENnw=";
  };

  caps = fetchurl {
    url = "https://raw.githubusercontent.com/xeji01/nothingfont/${rev}/fonts/Ndot57Caps-Regular.otf";
    hash = "sha256-AWIe6ZnjowzUlzCh3iFeTSw/RvOpcZIK6Y8Nep4z5Sk=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "ndot-57";
  version = "unstable-2025-04-27";

  src = regular;
  dontUnpack = true;

  installPhase = ''
    install -Dm644 "$src" "$out/share/fonts/opentype/Ndot57-Regular.otf"
    install -Dm644 ${caps} "$out/share/fonts/opentype/Ndot57Caps-Regular.otf"
  '';

  meta = {
    description = "Ndot-57, the tighter Ndot dot-matrix variant used by Nothing";
    homepage = "https://github.com/xeji01/nothingfont";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
  };
}
