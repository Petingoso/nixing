{
  config,
  inputs,
  lib,
  ...
}:
let
  inherit (config.custom) username;
in
{
  config = {
    environment.sessionVariables = rec {
      XDG_BIN_HOME = "$HOME/.local/bin";
      PATH = [
        "${XDG_BIN_HOME}"
      ];
    };

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "bkup-home-manager-${toString inputs.self.lastModifiedDate}";
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
