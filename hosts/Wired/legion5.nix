{
  lib,
  inputs,
  ...
}: {
  imports = [inputs.nixos-hardware.nixosModules.lenovo-legion-15arh05h];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    prime.amdgpuBusId = lib.mkForce "PCI:5:0:0"; ##override nixosHardware option
    powerManagement.enable = true;
  };
  services.xserver.videoDrivers = ["nvidia" "amdgpu"];
  specialisation = {
    disable-dGPU = {
      configuration = {
        system.nixos.tags = ["no-dGPU"];
        hardware.nvidiaOptimus.disable = true;
      };
    };
  };
}
