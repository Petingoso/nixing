{
  inputs,
  self,
  ...
}: let
  mkHost = {
    channel,
    system ? "x86_64-linux",
    hostDir,
    extraModules ? [],
    hostname,
    enableHM ? false,
  }: let
    pkgs =
      if channel == "stable"
      then inputs.nixpkgs-stable
      else inputs.nixpkgs-unstable;
    lib = pkgs.lib;

    hm =
      if enableHM
      then
        (
          if channel == "stable"
          then inputs.home-manager-stable
          else inputs.home-manager-unstable
        )
      else null;

    hostExtraModules =
      (import (hostDir + "/modules.nix") {
        inherit self lib;
      }).imports;
  in
    pkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit
          inputs
          self
          lib
          ;
      };

      modules =
        [
          hostDir
          "${self}/modules/core"
          (import "${self}/options" {inherit hostname system;}).imports

          (
            {
              config,
              lib,
              ...
            }: {
              config.custom.enableHM = enableHM;
            }
          )
        ]
        ++ lib.optional enableHM hm.nixosModules.home-manager
        ++ hostExtraModules
        ++ extraModules;
    };
in {
  Wired = mkHost {
    channel = "unstable";
    hostname = "Wired";
    hostDir = ./Wired;
    enableHM = true;
    extraModules = (import ../modules/desktop {}).imports;
  };
}
