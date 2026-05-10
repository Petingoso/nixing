{
  stm32cubeide,
  requireFile,
}: let
  version = "2.1.0";
  buildNumber = "27993";
  tarballName = "st-stm32cubeide_${version}_${buildNumber}_20260219_1630_amd64.tar.gz";
in
  stm32cubeide.overrideAttrs (old: {
    inherit version;

    src = requireFile {
      name = tarballName;
      sha256 = "18mgcwby6ycp9bc2wn3wdajx0i5m1bg16vbal09hm4x4x6dq113f";
      message = ''
        Please download ${tarballName} from:
        https://www.st.com/en/development-tools/stm32cubeide.html

        Then add it to the Nix store via:
        nix-store --add-fixed sha256 ${tarballName}
      '';
    };
  })
