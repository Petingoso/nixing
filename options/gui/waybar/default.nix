{
  config,
  lib,
  ...
}: let
  rofi-menu = "rofi -show drun -theme ~/.config/rofi/launchers/menu.rasi";
in {
  options.mystuff.programs = {
    waybar.enable = lib.mkEnableOption "waybar";
  };
  config = lib.mkIf config.mystuff.programs.waybar.enable {
    home-manager.users.${config.mystuff.other.system.username} = {
      programs.waybar = {
        enable = true;
        settings = [
          {
            position = "left";
            layer = "top";
            modules-left = ["custom/icon" "hyprland/workspaces"];
            modules-right = [
              "custom/notification"
              "tray"
              "battery"
              "custom/separator"
              "clock"
              "custom/power"
            ];

            "hyprland/workspaces" = {
              all-outputs = true;
              on-click = "activate";
              format = "{icon}";
              format-icons = {
                "1" = "ー";
                "2" = "二";
                "3" = "三";
                "4" = "四";
                "5" = "五";
                "6" = "六";
                "7" = "七";
                "8" = "八";
                "9" = "九";
                "10" = "〇";
                "default" = "一";
              };
            };

            "custom/power" = {
              format = "⏻";
              on-click = "~/.local/bin/powermenu";
            };

            "clock" = {
              format = "{:%H\n%M}";
              tooltip-format = "<big>{:%Y %B}</big><tt><small>{calendar}</small></tt>";
            };

            "custom/icon" = {
              format = "";
              on-click = "${rofi-menu}";
            };

            "custom/separator" = {format = "──────";};

            "battery" = {format = "{capacity}%";};

            "custom/notification" = {
              tooltip = false;
              format = "{icon}";
              format-icons = {
                notification = "󰂞 ";
                none = "󰂚 ";
                dnd-notification = "󰂠 <span foreground='red'><sup></sup></span>";
                dnd-none = "󰂛 ";
              };

              return-type = "json";
              exec-if = "which swaync-client";
              exec = "swaync-client -swb";
              on-click = "swaync-client -C";
              on-click-right = "swaync-client -d -sw";
              escape = true;
            };

            "tray" = {show-passive-items = true;};
          }
        ];

        style = ./style.css;
      };
    };
  };
}
