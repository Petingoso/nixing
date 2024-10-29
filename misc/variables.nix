{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkOption;
  inherit (lib.types) str;
in {
  options = {
    lock_cmd = mkOption {type = str;};
    rofi-menu = mkOption {type = str;};
  };
  config = {
    lock_cmd = "${pkgs.playerctl}/bin/playerctl pause; ${config.programs.hyprlock.package}/bin/hyprlock";
    rofi-menu = "rofi -show drun -theme ~/.config/rofi/launchers/menu.rasi";
  };
}
