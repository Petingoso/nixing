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
  options.mystuff.programs.nh = {
    enable = mkEnableOption "nh";
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
        enable = true;
        dates = "weekly";
        extraArgs = "--keep 10";
      };
    };
  };
}
