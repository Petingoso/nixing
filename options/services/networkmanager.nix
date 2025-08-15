{
  config,
  lib,
  ...
}: let
  cfg = config.custom.services.networkmanager;

  inherit (lib.options) mkOption;
  inherit (lib.types) bool;
in {
  options.custom.services.networkmanager = {
    enable = mkOption {
      description = "enable networkmanager";
      type = bool;
    };

    powersave = mkOption {
      description = "networkmanager powersaving";
      type = bool;
      default = false;
    };
  };

  config = {
    networking = {
      networkmanager = {
        enable = cfg.enable;
        wifi.powersave = cfg.powersave;
      };
    };
  };
}
