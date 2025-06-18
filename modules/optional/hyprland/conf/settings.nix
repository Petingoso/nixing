{
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    source = "/tmp/themes/hyprland/hypr_theme";

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

    gestures = {
      workspace_swipe = true;
      workspace_swipe_invert = true;
    };

    general = {
      gaps_in = 5;
      gaps_out = 5;
      border_size = 2;
      layout = "dwindle";
    };

    dwindle = {preserve_split = true;};

    animations = {enabled = 1;};

    decoration = {
      rounding = 3;
      blur.enabled = true;
      blur.size = 8;
      blur.passes = 2;
      blur.new_optimizations = true;
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

    # misc.disable_hyprland_logo = true;
    misc.vfr = true;

    windowrule = [
      "opacity 0.95,title:^(discord)$"
      "tile,title:^(huiontablet)$"
      "float,title:^(qalculate)"
      "float,title:^(Rofi)"
    ];

    windowrulev2 = [
      "idleinhibit fullscreen, title:(.*?)" # dont block if any app is on fullscreen

      ''
        opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$
      ''

      "noanim,class:^(xwaylandvideobridge)$"
      "nofocus,class:^(xwaylandvideobridge)$"
      "noinitialfocus,class:^(xwaylandvideobridge)$"
    ];

    layerrule = ["blur, swaync-control-center" "ignorezero, swaync-control-center"];

    workspace = ["w[t1], gapsout:0, border:0"];
  };
}
