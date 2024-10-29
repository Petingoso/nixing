{
  lib,
  config,
  pkgs,
  ...
}: {
  options.mystuff.programs = {
    rofi.enable = lib.mkEnableOption "rofi";
  };
  config = lib.mkIf config.mystuff.programs.rofi.enable {
    home-manager.users.${config.mystuff.other.system.username} = {
      programs.rofi.package = pkgs.rofi-wayland;
      programs.rofi = {
        enable = true;
        configPath = ""; #workaround so the package doesnt overwrite the custom config.rasi
      };

      xdg.configFile = {
        "rofi/config.rasi".source = ./config.rasi;

        "rofi/launchers/menu.rasi".source = ./launchers/menu.rasi;
        "rofi/launchers/power.rasi".source = ./launchers/power.rasi;
        "rofi/launchers/theme.rasi".source = ./launchers/theme.rasi;
        "rofi/launchers/shared/colors.rasi".source = ./launchers/shared/colors.rasi;
        "rofi/launchers/shared/fonts.rasi".source = ./launchers/shared/fonts.rasi;
      };
    };
  };
}
