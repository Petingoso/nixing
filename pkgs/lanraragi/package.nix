{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  makeBinaryWrapper,
  perl,
  ghostscript,
  nixosTests,
  nix-update-script,
}:
let 
Mojolicious = (buildPerlPackage {
    pname = "Mojolicious";
    version = "9.36";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SR/SRI/Mojolicious-9.36.tar.gz";
      hash = "sha256-UX7Pb9hqC3xhadVRAiOL+YUWGNt2L7ANTPDZTGJSAV8=";
    };
    meta = {
      description = "Real-time web framework";
      homepage = "https://mojolicious.org";
      license = with lib.licenses; [ artistic2 ];
      maintainers = with maintainers; [ marcusramberg sgo thoughtpolice ];
      mainProgram = "mojo";
    };
  });
in
{
buildNpmPackage rec {
  pname = "lanraragi";
  version = "0.9.40";

  src = fetchFromGitHub {
    owner = "Difegue";
    repo = "LANraragi";
    tag = "v.${version}";
    hash = "sha256-HF2g8rrcV6f6ZTKmveS/yjil/mBxpvRUFyauv5f+qQ8=";
  };

  patches = [
    ./install.patch
    ./fix-paths.patch
    ./expose-password-hashing.patch # Used by the NixOS module
  ];

  npmDepsHash = "sha256-RAjZGuK0C6R22fVFq82GPQoD1HpRs3MYMluUAV5ZEc8=";

  nativeBuildInputs = [
    perl
    makeBinaryWrapper
  ];

  buildInputs =
    with perl.pkgs;
    [
      perl
      ImageMagick
      locallib
      Redis
      Encode
      ArchiveLibarchiveExtract
      ArchiveLibarchivePeek
      ListMoreUtils
      NetDNSNative
      SortNaturally
      AuthenPassphrase
      FileReadBackwards
      URI
      LogfileRotate
      Mojolicious
      MojoliciousPluginTemplateToolkit
      MojoliciousPluginRenderFile
      MojoliciousPluginStatus
      IOSocketSocks
      IOSocketSSL
      CpanelJSONXS
      Minion
      MinionBackendRedis
      ProcSimple
      ParallelLoops
      SysCpuAffinity
      FileChangeNotify
      ModulePluggable
      TimeLocal
      YAMLPP
      StringSimilarity

      CacheFastMmap
      LocaleMaketextLexicon
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ LinuxInotify2 ];

  buildPhase = ''
    runHook preBuild

    # Check if every perl dependency was installed
    # explicitly call cpanm with perl because the shebang is broken on darwin
    perl ${perl.pkgs.Appcpanminus}/bin/cpanm --installdeps ./tools --notest

    perl ./tools/install.pl install-full
    rm -r node_modules public/js/vendor/*.map public/css/vendor/*.map

    runHook postBuild
  '';

  doCheck = true;

  nativeCheckInputs = with perl.pkgs; [
    TestMockObject
    TestTrap
    TestDeep
  ];

  checkPhase = ''
    runHook preCheck

    rm tests/plugins.t # Uses network
    prove -r -l -v tests

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/lanraragi
    chmod +x script/launcher.pl
    cp -r lib public script templates package.json lrr.conf $out/share/lanraragi

    makeWrapper $out/share/lanraragi/script/launcher.pl $out/bin/lanraragi \
      --prefix PERL5LIB : $PERL5LIB \
      --prefix PATH : ${lib.makeBinPath [ ghostscript ]} \
      --run "cp -n --no-preserve=all $out/share/lanraragi/lrr.conf ./lrr.conf 2>/dev/null || true" \
      --add-flags "-f $out/share/lanraragi/script/lanraragi"

    makeWrapper ${lib.getExe perl} $out/bin/helpers/lrr-make-password-hash \
      --prefix PERL5LIB : $out/share/lanraragi/lib:$PERL5LIB \
      --add-flags "-e 'use LANraragi::Controller::Config; print LANraragi::Controller::Config::make_password_hash(@ARGV[0])' 2>/dev/null"

    runHook postInstall
  '';

  passthru.tests.module = nixosTests.lanraragi;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v\\.(.*)"
    ];
  };

  meta = {
    changelog = "https://github.com/Difegue/LANraragi/releases/tag/${src.tag}";
    description = "Web application for archival and reading of manga/doujinshi";
    homepage = "https://github.com/Difegue/LANraragi";
    license = lib.licenses.mit;
    mainProgram = "lanraragi";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.unix;
  };
}
}
