{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mystuff.programs.nh;

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

  config = mkIf cfg.enable {
    # nix.settings = {
    #     substituters = [
    #         "https://viperml.cachix.org"
    #     ];
    #     trusted-public-keys = [
    #         "viperml.cachix.org-1:qZhKBMTfmcLL+OG6fj/hzsMEedgKvZVFRRAhq7j8Vh8="
    #     ];
    # };

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
