{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.attrsets) attrValues;
in {
  # https://github.com/NixOS/nixos-hardware/blob/master/common/gpu/amd/default.nix
  services.xserver.videoDrivers = ["modesetting"];

  hardware = {
    amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = attrValues {
        inherit
          (pkgs)
          mesa
          libdrm
          libva
          libva-vdpau-driver
          libvdpau-va-gl
          ;
      };
      extraPackages32 = attrValues {
        inherit
          (pkgs.driversi686Linux)
          mesa
          libvdpau-va-gl
          ;
      };
    };
  };

  boot.initrd.kernelModules = ["amdgpu"];

  environment.sessionVariables = {
    AMD_VULKAN_ICD = "RADV";
  };
}
