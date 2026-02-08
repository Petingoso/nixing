{stdenv}:
stdenv.mkDerivation {
  pname = "custom-scripts";
  version = "1.0";

  src = ./scripts;

  installPhase = ''
    mkdir -p $out/bin
    for f in *.sh; do
      install -m755 "$f" "$out/bin/''${f%.sh}"
    done
  '';
}
