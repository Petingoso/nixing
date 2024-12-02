{
  lib,
  inputs,
  ...
}: {
  imports = [inputs.nixos-hardware.nixosModules.lenovo-thinkpad.t480];
}
