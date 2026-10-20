{
  lib,
  stdenvNoCC,
  fetchurl,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "monolisa";
  version = "2.015";

  src = fetchurl {
    url = "https://github.com/27Aaron/Fonts/releases/download/v1.0.0/MonoLisa-2.015.tar.xz";
    hash = "sha256-wm7XHFx6ReVUE5CRXBIfbrC+eDBouO69jKIW0F5bvN4=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "MonoLisa, a coding font designed for developers";
    homepage = "https://www.monolisa.dev";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
  };
}
