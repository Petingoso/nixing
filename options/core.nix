{
  lib,
  config,
  enableHM,
  ...
}:
let
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
      description = "System Hostname";
    };

    platform = mkOption {
      type = types.str;
      default = "x86_64-linux";
      description = "System Architecture";
    };

    programs.shell = mkOption {
      type = types.str;
      default = "zsh";
      description = "Shell program (used in greetd)";
    };
  };

  config = {
    networking.hostName = cfg.hostname;
    nixpkgs.system = cfg.platform;

    users.users.${cfg.username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };

  } 
  // lib.optionalAttrs enableHM {
    home-manager.users.${cfg.username}.home.stateVersion = config.system.stateVersion;
};
}
