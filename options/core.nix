{
  lib,
  config,
  ...
}:
with lib; {
  options.custom = {
    username = mkOption {
      type = types.str;
      default = "pet";
      description = "The name of the primary user.";
    };

    enableHomeManager = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Home Manager integration";
    };
  };

  config = {
    users.users.${config.custom.username} = {
      isNormalUser = true;
      extraGroups = ["wheel"];
    };

    home-manager.users.${config.custom.username}.home.stateVersion =
      lib.mkIf config.custom.enableHomeManager config.system.stateVersion;
  };
}
