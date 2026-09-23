{
  config,
  lib,
  enableHM,
  ...
}:
let
  cfg = config.custom.programs.nh;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str;
in
{
  options.custom.programs.nh = {
    enable = mkEnableOption "nh";
    clean.enable = mkEnableOption "enable gc";
    flake = mkOption {
      type = str;
      description = "flake directory";
    };
  }
  // lib.optionalAttrs enableHM {
    config = mkIf (cfg.enable) {
      programs.nh = {
        enable = true;
        inherit (cfg) flake;
        clean = {
          enable = cfg.clean.enable;
          dates = "weekly";
          extraArgs = "--keep 10";
        };
      };
    };
  };
}
