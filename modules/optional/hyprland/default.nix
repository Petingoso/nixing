{
  # inputs,
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkOption;
  inherit (lib.types) str;
in {
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
