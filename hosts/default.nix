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
      ignoreOverride ? [ ],
    }:
    let
      pkgs = if channel == "stable" then inputs.nixpkgs-stable else inputs.nixpkgs-unstable;
      lib = pkgs.lib;

      hm =
        if enableHM then
          (if channel == "stable" then inputs.home-manager-stable else inputs.home-manager-unstable)
        else
          null;

      hostExtraModules =
        (import (hostDir + "/modules.nix") {
          inherit self lib;
        }).imports;
    in
    lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          self
          lib
          hostname
          system
          ;
        nixpkgs = pkgs;
      };

      modules =
        lib.flatten [
          hostDir
          "${self}/modules/core"
          (import "${self}/options" { }).imports

          (
            { config, ... }:
            {
              config = {
                nix.registry =
                  let
                    # We map over all inputs, but skip the ones in ignoreOverride
                    shouldOverride = name: !(builtins.elem name ignoreOverride);
                  in
                  {
                    nixpkgs.flake = pkgs;
                  }
                  // (lib.mapAttrs (name: value: { flake = value; }) (
                    lib.filterAttrs (name: _: shouldOverride name) inputs
                  ));

                nix.nixPath = [ "nixpkgs=${pkgs}" ];
                custom.enableHM = enableHM;
              };
            }
          )
        ]
        ++ lib.optional enableHM hm.nixosModules.home-manager
        ++ hostExtraModules
        ++ extraModules;
    };
  ignoreOverride = [ "hyprland" ];
in
{
  Wired = mkHost {
    channel = "unstable";
    hostname = "Wired";
    hostDir = ./Wired;
    enableHM = true;
    extraModules = (import ../modules/desktop { }).imports;
    ignoreOverride = ignoreOverride;
  };
  HeadEmpty = mkHost {
    channel = "unstable";
    hostname = "HeadEmpty";
    hostDir = ./HeadEmpty;
    enableHM = true;
    extraModules = (import ../modules/desktop { }).imports;
    ignoreOverride = ignoreOverride;
  };
  teto = mkHost {
    channel = "stable";
    hostname = "teto";
    hostDir = ./teto;
    enableHM = true;
    extraModules = (import ../modules/desktop { }).imports;
    ignoreOverride = ignoreOverride;
  };
  furry-femboys = mkHost {
    channel = "stable";
    hostname = "furry-femboys";
    hostDir = ./furry-femboys;
    enableHM = false;
    system = "aarch64-linux";
    ignoreOverride = ignoreOverride;
  };
}
