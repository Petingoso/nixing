{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  gtk-engine-murrine,
}:
stdenvNoCC.mkDerivation rec {
  pname = "gruvbox-material-gtk";
  version = "a1295d8bcd4dfbd0cd6793d7b1583b442438ed89";

  src = fetchFromGitHub {
    owner = "TheGreatMcPain";
    repo = "gruvbox-material-gtk";
    rev = "a1295d8bcd4dfbd0cd6793d7b1583b442438ed89";
    sha256 = "VumO8F4ZrFI6GZU1XXaw4MCnP+Nla1rVS3uuSUzpl9E=";
  };

  buildInputs = [gtk-engine-murrine];

  propagatedUserEnvPkgs = [];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes/
    cp -r $src/themes/* $out/share/themes/

    runHook postInstall
  '';

  meta = with lib; {
    description = "diy gruvbox theme";
    homepage = "https://github.com/TheGreatMcPain/gruvbox-material-gtk";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [petingoso];
  };
}
