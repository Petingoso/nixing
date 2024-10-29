{config, ...}: {
  hardware.cpu.amd.updateMicrocode = true;

  boot = {
    # https://github.com/NixOS/nixos-hardware/blob/master/common/cpu/amd/pstate.nix
    kernelParams = ["amd_pstate=active"];

    # https://github.com/NixOS/nixos-hardware/blob/master/common/cpu/amd/zenpower.nix
    blacklistedKernelModules = ["k10temp"];
    extraModulePackages = [config.boot.kernelPackages.zenpower];
    kernelModules = ["zenpower"];
  };
}
