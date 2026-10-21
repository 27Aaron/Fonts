{
  lib,
  stdenvNoCC,
  fetchurl,
  installFonts,
}:

stdenvNoCC.mkDerivation rec {
  pname = "lxgw-wenkai-tc";
  version = "1.530";

  src = fetchurl {
    url = "https://github.com/lxgw/LxgwWenKaiTC/releases/download/v${version}/lxgw-wenkai-tc-v${version}.tar.gz";
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
