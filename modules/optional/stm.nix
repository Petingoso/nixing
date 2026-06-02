{ pkgs,inputs, ... }:
{
  imports = [
    inputs.stm-nix.nixosModules.default
  ];

  programs.stm32cubeide = {
    enable = true; # Enable STM32CubeIDE
    package = pkgs.callPackage ../../pkgs/stm.nix {
      stm32cubeide = inputs.stm-nix.packages.${pkgs.stdenv.hostPlatform.system}.stm32cubeide;
    };
    enableStlink = true; # Enable ST-Link udev rules (default: true)
    enableJlink = true; # Enable J-Link udev rules (default: true)
  };
}
