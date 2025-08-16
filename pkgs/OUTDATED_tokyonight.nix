{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation rec {
  pname = "tokyonight-gtk";
  version = "7d3c0554bffedb3339e04be2c747d7f68e7c0de1";

  src = fetchFromGitHub {
    owner = "Petingoso";
    repo = "TokyoNight";
    rev = "7d3c0554bffedb3339e04be2c747d7f68e7c0de1";
    sha256 = "MpEWT4ITHmenvufThrRIxIVpKBZcrM2nULFHNwL6sA0=";
  };

  buildInputs = [];

  propagatedUserEnvPkgs = [];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes/TokyoNight
    cp -r $src/* $out/share/themes/TokyoNight

    runHook postInstall
  '';

  meta = with lib; {
    description = "diy tokyonight theme";
    homepage = "https://github.com/Petingoso/TokyoNight";
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [petingoso];
  };
}
