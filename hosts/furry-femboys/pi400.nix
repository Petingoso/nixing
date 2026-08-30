{
  lib,
  inputs,
  config,
  pkgs,
  ...
}: {
# for kernel
nix.settings = {
  substituters = [
    "https://nix-community.cachix.org"
  ];
  trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];
};
  imports = [inputs.nixos-hardware.nixosModules.raspberry-pi-4];
  hardware = {
    enableRedistributableFirmware = true;
    raspberry-pi."4".apply-overlays-dtmerge.enable = true;
     deviceTree = {
       enable = true;
       filter = "*rpi-4-*.dtb";
     };
  };
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
    raspberrypifw
  ];
}
