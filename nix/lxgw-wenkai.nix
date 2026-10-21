{
  lib,
  stdenvNoCC,
  fetchurl,
  installFonts,
}:

stdenvNoCC.mkDerivation rec {
  pname = "lxgw-wenkai";
  version = "1.530";

  src = fetchurl {
    url = "https://github.com/lxgw/LxgwWenKai/releases/download/v${version}/lxgw-wenkai-v${version}.tar.gz";
    hash = "sha256-ojw3MPIaP+kYgc0oLrFdzeraF8ZXGNvGmw0mHKfB4QM=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "LXGW WenKai (霞鶩文楷), a Chinese handwriting-style font derived from Fontworks' Klee One";
    homepage = "https://github.com/lxgw/LxgwWenKai";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
