{
  lib,
  stdenvNoCC,
  fetchurl,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "pingfang";
  version = "21.0d1e1";

  src = fetchurl {
    url = "https://github.com/27Aaron/Fonts/releases/download/v1.0.0/PingFang-21.0d1e1.tar.xz";
    hash = "sha256-jEDHohB9ljhwM7W0isa4WVAX5ssF4XPlQv9fa3esJTQ=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "PingFang, Apple's Chinese font family (HK / MO / TC / SC)";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
  };
}
