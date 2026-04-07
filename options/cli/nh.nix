{
  config,
  lib,
  ...
}: let
  cfg = config.custom.programs.nh;
  HM = config.custom.enableHM;

  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str;
in {
  options.custom.programs.nh = {
    enable = mkEnableOption "nh";
    clean.enable = mkEnableOption "enable gc";
    flake = mkOption {
      type = str;
      description = "flake directory";
    };
  };

  config = mkIf (cfg.enable && HM) {
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
}
