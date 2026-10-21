{
  lib,
  stdenvNoCC,
  fetchurl,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "lxgw-wenkai-tc";
  version = "1.530";

  src = fetchurl {
    url = "https://github.com/lxgw/LxgwWenKaiTC/releases/download/v1.530/lxgw-wenkai-tc-v1.530.tar.gz";
    hash = "sha256-omCpK9EfTQZvrNpPlGVPWbgCeHTPEKLRaMd5XW00u5k=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "LXGW WenKai TC (霞鶩文楷 TC), a Traditional Chinese handwriting-style font family";
    homepage = "https://github.com/lxgw/LxgwWenKaiTC";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
