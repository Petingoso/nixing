{
  lib,
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [inputs.nixos-hardware.nixosModules.lenovo-legion-15arh05h];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    prime.amdgpuBusId = lib.mkForce "PCI:5:0:0"; # #override nixosHardware option
    powerManagement.enable = true;
  };
  services.xserver.videoDrivers = [
    "nvidia"
    "amdgpu"
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  specialisation = {
    disable-dGPU = {
      configuration = {
        system.nixos.tags = ["no-dGPU"];
        hardware.nvidiaOptimus.disable = true;
      };
    };
  };
}

