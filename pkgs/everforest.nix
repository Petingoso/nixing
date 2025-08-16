{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation rec {
  pname = "everforest-gtk";
  version = "020799c97981e2c03a674c1c22be57575b4ac3f7";

  src = fetchFromGitHub {
    owner = "Theory-of-Everything";
    repo = "everforest-gtk";
    rev = "020799c97981e2c03a674c1c22be57575b4ac3f7";
    sha256 = "yiugIUzQ8cOtxizamG/labJ3s2h5Z7mC0/l3N9ZwZWk=";
  };

  buildInputs = [];

  propagatedUserEnvPkgs = [];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes/everforest/
    cp -r $src/* $out/share/themes/everforest/
    rm $out/share/themes/everforest/{LICENSE,README.md}

    runHook postInstall
  '';

  meta = with lib; {
    description = "diy everforest theme";
    homepage = "https://github.com/theory-of-everything/everforest-gtk";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [petingoso];
  };
}
