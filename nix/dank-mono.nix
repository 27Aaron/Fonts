{
  lib,
  stdenvNoCC,
  fetchurl,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "dank-mono";
  version = "1.000";

  src = fetchurl {
    url = "https://github.com/27Aaron/Fonts/releases/download/v1.0.0/DankMono-1.000.tar.xz";
    hash = "sha256-dR/PavNcpcTs0woobd4pwoUjhb1iQ8Yxitu0gvtuFF8=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Dank Mono, a coding font with ligatures";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
  };
}
