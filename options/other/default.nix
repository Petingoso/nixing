{
  enableHM,
  config,
  lib,
  ...
}:
{

  imports = lib.optional enableHM ./home-manager.nix;

}
