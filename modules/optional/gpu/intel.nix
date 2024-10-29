{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.attrsets) attrValues;
in {
  # https://github.com/NixOS/nixos-hardware/blob/master/common/gpu/intel/default.nix
  boot.initrd.kernelModules = ["i915"];

  hardware.graphics = {
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
        intel-vaapi-driver
        intel-media-driver
        ;
    };
    extraPackages32 = attrValues {
      inherit
        (pkgs.driversi686Linux)
        mesa
        libvdpau-va-gl
        intel-vaapi-driver
        intel-media-driver
        ;
    };
  };
}
