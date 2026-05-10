{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) str;
in
{
  options.custom.programs = {
    launcher = mkOption {
      description = "launcher program";
      type = str;
      default = null;
    };
    locker = mkOption {
      description = "locker program";
      type = str;
      default = null;
    };
    power_menu = mkOption {
      description = "power_menu command";
      type = str;
      default = null;
    };
  };

  config = {
    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    programs.hyprland.enable = true;

    home-manager.users.${config.custom.username} = {
      imports = [
        # inputs.hyprland.homeManagerModules.default
        ./conf/binds.nix
        ./conf/exports.nix
        ./conf/startup.nix
        ./conf/settings.nix
      ];
      wayland.windowManager.hyprland.enable = true;
    };
    custom = {
      services.greetd.environments = [
        "start-hyprland"
      ];
    };
  };
}
