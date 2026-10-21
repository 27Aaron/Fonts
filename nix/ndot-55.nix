{
  lib,
  stdenvNoCC,
  fetchurl,
}:

let
  rev = "9d8b51d2e89fcf4d71f4d31e346a2b0ee4350716";

  regular = fetchurl {
    url = "https://raw.githubusercontent.com/xeji01/nothingfont/${rev}/fonts/Ndot55-Regular.otf";
    hash = "sha256-7wgfbB/SBBox7EJYlgtOhxgX+FRL6qgqVlYVxbmUfmA=";
  };

  caps = fetchurl {
    url = "https://raw.githubusercontent.com/xeji01/nothingfont/${rev}/fonts/Ndot55Caps-Regular.otf";
    hash = "sha256-LKEovSjCe8/MVhzfRTn3gERvWLFQUnhHXcaK9wLwLZw=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "ndot-55";
  version = "unstable-2025-04-27";

  src = regular;
  dontUnpack = true;

  installPhase = ''
    install -Dm644 "$src" "$out/share/fonts/opentype/Ndot55-Regular.otf"
    install -Dm644 ${caps} "$out/share/fonts/opentype/Ndot55Caps-Regular.otf"
  '';

  meta = {
    description = "Ndot-55, the dot-matrix typeface Nothing uses on its brand";
    homepage = "https://github.com/xeji01/nothingfont";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
  };
}
