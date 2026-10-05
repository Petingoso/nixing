{lib, ...}: let
  mkLua = lib.generators.mkLuaInline;
  monitor = {
    output,
    mode ? "preferred",
    position ? "auto",
    scale ? 1,
    transform ? null,
    disabled ? null,
  }: {
    _args = [
      (mkLua ''
        {
          output = "${output}",
          mode = "${mode}",
          position = "${position}",
          scale = ${toString scale}${
          lib.optionalString (transform != null) ''
            ,
            transform = ${toString transform}''
        }${
          lib.optionalString (disabled != null) ''
            ,
            disabled = ${lib.boolToString disabled}''
        }
        }
      '')
    ];
  };
in {
  wayland.windowManager.hyprland.settings = {
    monitor = [
      (monitor {
        output = "desc:Ancor Communications Inc ASUS VS247 F8LMTF187560";
        mode = "preferred";
        position = "auto";
        scale = 1;
        transform = 1;
      })

      (monitor {
        output = "";
        mode = "preferred";
        position = "auto";
        scale = 1;
      })
    ];

    config = {
      cursor.no_hardware_cursors = true;

      input = {
        sensitivity = 1;
        kb_layout = "pt";
        follow_mouse = 1;
        force_no_accel = true;
        natural_scroll = false;

        touchpad.disable_while_typing = false;
      };

      gesture = [
        "3, horizontal, workspace"
      ];

      general = {
        gaps_out = 10;
        border_size = 2;
        layout = "dwindle";
        resize_on_border = true;
      };

      dwindle = {
        preserve_split = true;
      };

      animations = {
        enabled = 1;
      };

      decoration = {
        rounding = 3;
        blur.enabled = false;
        blur.ignore_opacity = true;

        shadow = {
          enabled = true;
          range = 20;
          render_power = 2;
          color = "0x44000000";
          offset = "8 8";
        };
      };

      ecosystem.no_donation_nag = true;
      misc = {
        disable_hyprland_logo = true;
      };

      windowrule = [
        "match:title ^(.*)$, idle_inhibit fullscreen"
      ];
    };
  };
}
