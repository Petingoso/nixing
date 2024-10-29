{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.meta) getExe;
in {
  environment.sessionVariables = {
    CHROME_EXECUTABLE = getExe pkgs.ungoogled-chromium;
  };
}
