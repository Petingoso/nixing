{
  lib,
  python3,
  fetchFromGitHub,
  nixosTests,
  unstableGitUpdater,
  fetchPypi,
}: let
  python = python3.override {
    packageOverrides = final: prev: {
      flask-babel = prev.flask-babel.overrideAttrs (old: rec {
        version = "4.0.0";
        patches = [];
        src = fetchFromGitHub {
          owner = "python-babel";
          repo = "flask-babel";
          tag = "v${version}";
          hash = "sha256-BAT+oupy4MCSjeZ4hFtSKMkGU9xZtc7Phnz1mIsb2Kc=";
        };
      });
      setproctitle = prev.setproctitle.overrideAttrs (old: rec {
        version = "1.3.7";
        src = fetchPypi {
          pname = "setproctitle";
          inherit version;
          hash = "sha256-vCvJF2kcFTfVubyhRoQ3F2gJx+EeVpTKeanKEjRdy54=";
        };
      });
      pyyaml = prev.pyyaml.overrideAttrs (old: rec {
        version = "6.0.3";
        src = fetchFromGitHub {
          owner = "yaml";
          repo = "pyyaml";
          tag = version;
          hash = "sha256-jUooIBp80cLxvdU/zLF0X8Yjrf0Yp9peYeiFjuV8AHA=";
        };
      });
    };
  };
in
  python.pkgs.toPythonModule (
    python.pkgs.buildPythonApplication rec {
      pname = "searxng";
      version = "0-unstable-2025-10-10";
      pyproject = true;

      src = fetchFromGitHub {
        owner = "searxng";
        repo = "searxng";
        rev = "613c1aa8ebe3b22e5be01dad03ed52cc0fe0d729";
        # hash = lib.fakeHash;
        hash = "sha256-LUme9Hmpuxtf25JPNSWh7ieLWNUwqFnU3Gw/9TPguNg=";
      };

      nativeBuildInputs = with python.pkgs; [pythonRelaxDepsHook];

      pythonRemoveDeps = [
        "typer-slim" # we use typer instead
      ];

      pythonRelaxDeps = [
        "certifi"
        "httpx-socks"
        "lxml"
        "pygments"
        "valkey"
      ];

      preBuild = let
        versionString = lib.concatStringsSep "." (
          builtins.tail (lib.splitString "-" (lib.removePrefix "0-" version))
        );
        commitAbbrev = builtins.substring 0 8 src.rev;
      in ''
        export SEARX_DEBUG="true";

        cat > searx/version_frozen.py <<EOF
        VERSION_STRING="${versionString}+${commitAbbrev}"
        VERSION_TAG="${versionString}+${commitAbbrev}"
        DOCKER_TAG="${versionString}-${commitAbbrev}"
        GIT_URL="https://github.com/searxng/searxng"
        GIT_BRANCH="master"
        EOF
      '';

      build-system = with python.pkgs; [setuptools];

      dependencies = with python.pkgs;
        [
          babel
          brotli
          certifi
          cryptography
          fasttext-predict
          flask
          flask-babel
          httpx
          httpx-socks
          isodate
          jinja2
          lxml
          markdown-it-py
          msgspec
          pygments
          python-dateutil
          pyyaml
          setproctitle
          typer
          uvloop
          valkey
          whitenoise
        ]
        ++ httpx.optional-dependencies.http2
        ++ httpx-socks.optional-dependencies.asyncio;

      # tests try to connect to network
      doCheck = false;

      postInstall = ''
        # Create a symlink for easier access to static data
        mkdir -p $out/share
        ln -s ../${python.sitePackages}/searx/static $out/share/

        # copy config schema for the limiter
        cp searx/limiter.toml $out/${python.sitePackages}/searx/limiter.toml
      '';

      passthru = {
        tests = {
          searxng = nixosTests.searx;
        };
        updateScript = unstableGitUpdater {hardcodeZeroVersion = true;};
      };

      meta = with lib; {
        homepage = "https://github.com/searxng/searxng";
        description = "Fork of Searx, a privacy-respecting, hackable metasearch engine";
        license = licenses.agpl3Plus;
        mainProgram = "searxng-run";
        maintainers = with maintainers; [
          SuperSandro2000
          _999eagle
        ];
      };
    }
  )
