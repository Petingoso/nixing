{
  config,
  lib,
  ...
}: let
  cfg = config.mystuff.other.system;

  inherit (lib.options) mkOption;
  inherit (lib.types) str;
in {
  options.mystuff.other.system = {
    hostname = mkOption {
      description = "hostname for this system";
      type = str;
    };

    username = mkOption {
      description = "username for this system (doesn't support multi user yet)";
      type = str;
    };

    platform = mkOption {
      description = "system (the one you usually passed to nixosSystem)";
      type = str;
    };
  };

  config = {
    networking.hostName = cfg.hostname;

    users.users.${cfg.username} = {
      isNormalUser = true;
      extraGroups = ["wheel"];
    };

    nixpkgs.hostPlatform = cfg.platform;
  };
}
