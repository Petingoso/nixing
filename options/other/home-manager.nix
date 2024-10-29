{
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.mystuff.other.home-manager;
  inherit (config.mystuff.other.system) username;

  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;
in {
  options.mystuff.other.home-manager = {
    enable = mkEnableOption "home-manager";
  };

  imports = [inputs.home-manager.nixosModules.home-manager];

  config = mkIf cfg.enable {
    environment.sessionVariables = rec {
      XDG_BIN_HOME = "$HOME/.local/bin";
      PATH = [
        "${XDG_BIN_HOME}"
      ];
    };

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "hm_backup";
      users.${username} = {
        programs = {
          home-manager.enable = true;
        };

        home = {
          inherit username;
          homeDirectory = "/home/${username}";

          stateVersion = lib.mkDefault config.system.stateVersion;
        };
      };
    };
  };
}
