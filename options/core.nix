{
  lib,
  config,
  hostname ? null,
  system ? null,
  ...
}:
let
  inherit hostname system;
  cfg = config.custom;
in
with lib;
{
  options.custom = {
    username = mkOption {
      type = types.str;
      default = "pet";
      description = "The name of the primary user.";
    };

    enableHM = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Home Manager integration";
    };

    hostname = mkOption {
      type = types.str;
      default = hostname;
      description = "System Hostname";
    };

    platform = mkOption {
      type = types.str;
      default = system;
      description = "System Architecture";
    };
  };

  config = {
    networking.hostName = cfg.hostname;
    nixpkgs.hostPlatform = cfg.platform;

    users.users.${cfg.username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };

    home-manager.users.${cfg.username}.home.stateVersion =
      (lib.mkIf cfg.enableHM) config.system.stateVersion;
  };
}
