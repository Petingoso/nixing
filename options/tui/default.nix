{
  lib,
  enableHM,
  ...
}:
{
  imports = lib.optionals enableHM [
    ./ranger
    ./neovim
  ];
}
