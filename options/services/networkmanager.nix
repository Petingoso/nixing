{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mystuff.services.networkmanager;
  inherit (config.mystuff.other.system) username;
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
    users.users."${username}".extraGroups = [ "networkmanager" ];
    networking = {
      networkmanager = {
        enable = true;
        wifi.powersave = cfg.powersave;
        plugins = [pkgs.networkmanager-openvpn];
      };
    };
  };
}
