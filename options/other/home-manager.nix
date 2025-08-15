{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (config.custom) username enableHM;

  inherit (lib.modules) mkIf;

in {
  config = mkIf enableHM {
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

          #already defined in options/core.nix
          # stateVersion = lib.mkDefault config.system.stateVersion;
        };
      };
    };
  };
}
