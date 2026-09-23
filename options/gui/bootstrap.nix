{
  lib,
  ...
}:
{
  options.custom.programs.launcher = lib.mkOption {
    type = lib.types.str;
    description = "Command to toggle the launcher";
  };
  options.custom.programs.locker = lib.mkOption {
    type = lib.types.str;
    description = "Command to lock the screen";
  };
  options.custom.programs.power_menu = lib.mkOption {
    type = lib.types.str;
    description = "Command to toggle the power menu";
  };
}

