{
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    # source = "/tmp/themes/hyperland/hypr_theme";

    monitor = ",preferred,auto,1";

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
      blur.ignore_opacity = true;

      shadow = {
        enabled = true;
        range = 20;
        render_power = 2;
        ignore_window = true;
        color = "0x44000000";
        offset = "8 8";
      };
    };

    ecosystem.no_donation_nag = true;
    # misc = {
    #   disable_hyprland_logo = true;
    # };

    windowrule =
      [
        "match:title (.*?), idle_inhibit fullscreen" # dont block if any app is on fullscreen

        "match:class ^(qalculate-gtk)$, float on"
      ]
      ++ [
        {
          name = "xwayland-video-bridge-fixes";
          "match:class" = "xwaylandvideobridge";

          no_initial_focus = true;
          no_focus = true;
          no_anim = true;
          no_blur = true;
          max_size = "1 1";
          opacity = 0.0;
        }
      ];

    # layerrule = ["blur, swaync-control-center" "ignorezero, swaync-control-center"];

    # workspace = ["w[t1], gapsout:0, border:0"];
  };
}
