{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "zpix";
  version = "3.3.0";

  src = fetchurl {
    url = "https://github.com/SolidZORO/zpix-pixel-font/releases/download/v${version}/zpix.ttf";
    hash = "sha256-pnkX2Uu1l6y987/hz5cEfMPhzdODnSHaGI41zAc36Cg=";
  };

  dontUnpack = true;

  installPhase = ''
    install -Dm644 "$src" "$out/share/fonts/truetype/zpix.ttf"
  '';

  meta = {
    description = "Zpix (最像素), a 12px pixel font for Latin, Chinese and Japanese";
    homepage = "https://github.com/SolidZORO/zpix-pixel-font";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
  };
}
