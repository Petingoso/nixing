{
  lib,
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [inputs.nixos-hardware.nixosModules.raspberry-pi .4];
  hardware = {
    enableRedistributableFirmware = true;
    raspberry-pi."4".apply-overlays-dtmerge.enable = true;
    deviceTree = {
      enable = true;
      filter = "*rpi-4-*.dtb";
    };

    environment.systemPackages = with pkgs; [
      libraspberrypi
      raspberrypi-eeprom
      raspberrypifw
    ];
  };
}
