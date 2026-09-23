{
  buildGoModule,
  fetchFromGitHub,
  lib,
  stdenv,
  pnpm_11,
  nodejs_24,
}:
let
  pname = "linx-server-gabe565";
  version = "2026-08-15";

  src = fetchFromGitHub {
    owner = "gabe565";
    repo = "linx-server";
    rev = "34fb43876850cfae410f965901cefc6d992a7ac3";
    hash = "sha256-2loEPBcH5vzfzzku2JGlFc7ry6zOXJ2KbpjFpi4L3Kk=";
  };
  frontend-assets = stdenv.mkDerivation {
  pname = "${pname}-frontend";
  inherit version src;

  nativeBuildInputs = [
    pnpm_11.configHook
    nodejs_24
  ];

  sourceRoot = "${src.name}/assets/static";

 pnpmDeps = pnpm_11.fetchDeps {
   pname = "${pname}-pnpm-deps";
   inherit version;
   src = "${src}/assets/static";
   hash = "sha256-BgFd6euhm8IgvB921nNm2P9NjQk+Zu//mJeUP+drxvo=";
   fetcherVersion=4;
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
