{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.services.networkmanager;
  inherit (config.custom) username;

  inherit (lib.options) mkOption;
  inherit (lib.types) bool;
in {
  options.custom.services.networkmanager = {
    enable = mkOption {
      description = "enable networkmanager";
      type = bool;
      default = false;
    };

    powersave = mkOption {
      description = "networkmanager powersaving";
      type = bool;
      default = false;
    };
  };

  config = {
    users.users."${username}".extraGroups = ["networkmanager"];
    networking = {
      networkmanager = {
        enable = cfg.enable;
        wifi.powersave = cfg.powersave;
        plugins = [pkgs.networkmanager-openvpn];
      };
    };
  };
}
