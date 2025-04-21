{
  config,
  lib,
  ...
}: let
  cfg = config.mystuff.services.networkmanager;

  inherit (lib.options) mkOption;
  inherit (lib.types) bool;
in {
  options.mystuff.services.networkmanager = {
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
        enable = true;
        # dns = "systemd-resolved";
        # services.resolved.enable = true;
        wifi.powersave = cfg.powersave;
      };
    };

    services.resolved = {
      enable = true;
      fallbackDns = [
        "9.9.9.9"
        "2620:fe::fe"
      ];
    };
    users.users.${config.mystuff.other.system.username}.extraGroups = ["networkmanager"];
  };
}
