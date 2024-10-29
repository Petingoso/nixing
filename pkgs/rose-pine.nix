{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation rec {
  pname = "rose-pine-gtk";
  version = "95aa1f2b2cc30495b1fc5b614dc555b3eef0e27d";

  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Rose-Pine-GTK-Theme";
    rev = "95aa1f2b2cc30495b1fc5b614dc555b3eef0e27d";
    sha256 = "I9UnEhXdJ+HSMFE6R+PRNN3PT6ZAAzqdtdQNQWt7o4Y=";
  };

  buildInputs = [];

  propagatedUserEnvPkgs = [];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes/
    cp -r $src/themes/* $out/share/themes/

    runHook postInstall
  '';

  meta = with lib; {
    description = "diy rose-pine theme";
    homepage = "https://github.com/Fausto-Korpsvart/Rose-Pine-GTK-Theme";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [petingoso];
  };
}
