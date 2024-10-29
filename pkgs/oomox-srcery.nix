{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation rec {
  pname = "srcery-gtk";
  version = "0381a785ebbe7c6e6bc1808e6715cef49206caac";

  src = fetchFromGitHub {
    owner = "Petingoso";
    repo = "oomox-srcery";
    rev = "0381a785ebbe7c6e6bc1808e6715cef49206caac";
    sha256 = "RADWqcJS7RRu5SP2JKpf2UDaYIg+2jL8sX5ZMQICWq4=";
  };

  buildInputs = [];

  propagatedUserEnvPkgs = [];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes/oomox-srcery
    cp -r $src/* $out/share/themes/oomox-srcery

    runHook postInstall
  '';

  meta = with lib; {
    description = "diy srcery theme";
    homepage = "https://github.com/Petingoso/oomox-srcery";
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [petingoso];
  };
}
