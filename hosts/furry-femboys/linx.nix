{
  buildGoModule,
  fetchFromGitHub,
  lib,
  stdenv,
  pnpm_9,
  nodejs_22,
}:
let
  pname = "linx-server-gabe565";
  version = "2026-04-17";

  src = fetchFromGitHub {
    owner = "gabe565";
    repo = "linx-server";
    rev = "d1d5b4573c5712801a2a7eaeb8e3b4f687716bca";
    hash = "sha256-2loEPBcH5vzfzzku2JGlFc7ry6zOXJ2KbpjFpi4L3Kk=";
  };
  frontend-assets = stdenv.mkDerivation {
  pname = "${pname}-frontend";
  inherit version src;

  nativeBuildInputs = [
    pnpm_9.configHook
    nodejs_22
  ];

  sourceRoot = "${src.name}/assets/static";

 pnpmDeps = pnpm_9.fetchDeps {
   pname = "${pname}-pnpm-deps";
   inherit version;
   src = "${src}/assets/static";
   hash = "sha256-b+GpAvpqV62z3ENCwwMhN0knD8hpvNzDf0PRrHQu7xo=";
   fetcherVersion = 3;
  };

  buildPhase = ''
    runHook preBuild
    pnpm build
    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out
    cp -r dist/. $out/
  '';
};
in
buildGoModule {
  inherit pname version src;

  vendorHash = "sha256-M/navDB3srWJJ34Xn7SGbwSbH8KC72WGTBTDZYwS55A=";

  preBuild = ''
    rm -rf assets/static/dist
    mkdir -p assets/static/dist
    cp -r ${frontend-assets}/. assets/static/dist/
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Modernized self-hosted file/media sharing website (gabe565 fork)";
    homepage = "https://github.com/gabe565/linx-server";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
