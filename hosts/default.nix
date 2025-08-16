{
  inputs,
  self,
  ...
}:
let
  mkHost =
    {
      channel,
      system ? "x86_64-linux",
      hostDir,
      extraModules ? [ ],
      hostname,
      enableHM ? false,
    }:
    let
      pkgs = if channel == "stable" then inputs.nixpkgs-stable else inputs.nixpkgs-unstable;
      lib = pkgs.lib;

      hm =
        if enableHM then
          (if channel == "stable" then inputs.home-manager-stable else inputs.home-manager-unstable)
        else
          null;

      # hostExtraModules =
      #   (import (hostDir + "/modules.nix") {
      #     inherit self lib;
      #   }).imports;
    in
    lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          self
          lib
          system
          hostname
          ;
      };

      modules =
        lib.flatten [
          # for the options nested list
          hostDir
          "${self}/modules/core"
          (import "${self}/options" { }).imports

          (
            { config, ... }:
            {
              config.custom.enableHM = enableHM;
            }
          )
        ]
        ++ lib.optional enableHM hm.nixosModules.home-manager
        # ++ hostExtraModules
        ++ extraModules;
    };
in
{
  Wired = mkHost {
    channel = "unstable";
    hostname = "Wired";
    hostDir = ./Wired;
    enableHM = true;
    extraModules = (import ../modules/desktop { }).imports;
  };
  HeadEmpty = mkHost {
    channel = "unstable";
    hostname = "HeadEmpty";
    hostDir = ./HeadEmpty;
    enableHM = true;
    extraModules = (import ../modules/desktop { }).imports;
  };
  teto = mkHost {
    channel = "unstable";
    hostname = "Wired";
    hostDir = ./teto;
    enableHM = true;
    extraModules = (import ../modules/desktop { }).imports;
  };
  furry-femboys = mkHost {
    channel = "stable";
    hostname = "Wired";
    hostDir = ./furry-femboys;
    enableHM = false;
    system = "aarch64-linux";

  };
}
