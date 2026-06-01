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
  		#   markdown-it-py = prev.markdown-it-py.overrideAttrs (old: rec {
  		#     version = "3.0.0";
  		#     src = fetchFromGitHub {
  		# 			owner = "executablebooks";
  		# 			repo = "markdown-it-py";
  		# 			tag = "v${version}";
  		# 			hash = "sha256-cmjLElJA61EysTUFMVY++Kw0pI4wOIXOyCY3To9fpQc=";
  		# };
  		#   });
	#      flask-babel = prev.flask-babel.overrideAttrs (old: rec {
	#        version = "4.0.0";
	#        patches = [];
	#        src = fetchFromGitHub {
	#          owner = "python-babel";
	#          repo = "flask-babel";
	#          tag = "v${version}";
	#          hash = "sha256-BAT+oupy4MCSjeZ4hFtSKMkGU9xZtc7Phnz1mIsb2Kc=";
	#        };
	#      });
	     babel = prev.babel.overrideAttrs (old: rec {
	 	version = "2.18.0";
	 	src = fetchPypi {
	  	 pname = "babel";
	         inherit version;
	   	 hash = "sha256-uAuZoUvQhfys+hXJFl9lH7s0BuZsxgOr8RxXUJN8mS0=";
	 	};
	    });
	#      msgspec = prev.msgspec.overrideAttrs (old: rec {
	#  	version = "0.20.0";
	#  	src = fetchPypi {
	#   pname = "msgspec";
	#          inherit version;
	#    	  hash = "sha256-aSNJ5Yj94yKHX40wJawBaJ/q1ZAef7GNaHCkRRnWKik=";
	#  	};
	# nativeBuildInputs = (old.nativeBuildInputs or []) ++ [
	#    		prev.setuptools
	#    		prev.setuptools-scm
	#  	];
	#     });
      # pyyaml = prev.pyyaml.overrideAttrs (old: rec {
      #   version = "6.0.3";
      #   src = fetchFromGitHub {
      #     owner = "yaml";
      #     repo = "pyyaml";
      #     tag = version;
      #     hash = "sha256-jUooIBp80cLxvdU/zLF0X8Yjrf0Yp9peYeiFjuV8AHA=";
      #   };
      # });
    };
  };
in
  python.pkgs.toPythonModule (
    python.pkgs.buildPythonApplication rec {
      pname = "searxng";
      version = "0-unstable-2026-01-26";
      pyproject = true;

      src = fetchFromGitHub {
        owner = "searxng";
        repo = "searxng";
        rev = "2bb8ac17c664b71cc7110acaaa5d4200c8a9bd0b";
        # hash = lib.fakeHash;
        hash = "sha256-kQfqRCD51s/o+1Ipjf+N3virh9wp8fePYZgFhoD1lbo=";
      };

      nativeBuildInputs = with python.pkgs; [pythonRelaxDepsHook];

      pythonRemoveDeps = [
        "typer-slim" # we use typer instead
      ];

   pythonRelaxDeps = [
      "certifi"
      "flask"
      "flask-babel"
      "httpx-socks"
      "lxml"
      "msgspec"
      "typer-slim"
      "whitenoise"
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

	dependencies =
      with python.pkgs;
      [
        babel
        certifi
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
        sniffio
        typer-slim
        typing-extensions
        valkey
        whitenoise
	typer
	cloudscraper
      ]
      ++ httpx.optional-dependencies.http2
      ++ httpx.optional-dependencies.socks
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

