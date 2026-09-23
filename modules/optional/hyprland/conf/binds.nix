{
  pkgs,
  osConfig,
  lib,
  ...
}:
let
  launcher-cmd = osConfig.custom.programs.launcher;
  lock-cmd = osConfig.custom.programs.locker;
  power-cmd = osConfig.custom.programs.power_menu;

  mod = "ALT";

  mkLua = lib.generators.mkLuaInline;

  bind = key: luaExpr: {
    _args = [
      key
      (mkLua luaExpr)
    ];
  };

  exec = key: cmd: bind key "hl.dsp.exec_cmd(\"${cmd}\")";
  group = key: action: bind key "hl.dsp.group.${action}";

  focus = key: direction: bind "${mod} + ${key}" "hl.dsp.focus({ direction = '${direction}' })";

  move =
    key: direction: bind "${mod} + SHIFT + ${key}" "hl.dsp.window.move({ direction = '${direction}' })";

  monitor = key: direction: bind "${mod} + ${key}" "hl.dsp.focus({ monitor = '${direction}' })";

  moveMonitor =
    key: direction:
    bind "${mod} + SHIFT + ${key}" "hl.dsp.window.move({ monitor = '${direction}', follow = false })";

  workspace = key: number: bind "${mod} + ${key}" "hl.dsp.focus({ workspace = ${number} })";

  moveWorkspace =
    key: number:
    bind "${mod} + SHIFT + ${key}" "hl.dsp.window.move({ workspace = ${number}, follow = false })";

  gesture = fingers: direction: action: args: {
    _args = [
      (mkLua ''
        {
          fingers = ${toString fingers},
          direction = "${direction}",
          action = "${action}"${lib.optionalString (args != "") ", ${args}"}
        }
      '')
    ];
  };

  workspaces = builtins.concatLists (
    builtins.genList (
      x:
      let
        wsKey = builtins.toString (if x == 9 then 0 else x + 1);
        wsNum = builtins.toString (x + 1);
      in
      [
        (workspace wsKey wsNum)
        (moveWorkspace wsKey wsNum)
      ]
    ) 10
  );
in
{
  home.packages = with pkgs; [
    playerctl
    qalculate-gtk
  ];

  wayland.windowManager.hyprland.settings = {
    gesture = [
      (gesture 3 "horizontal" "workspace" "")
      (gesture 2 "pinch" "cursor_zoom" "mods = \"SHIFT\", zoom_level = 1, mode = \"live\"")
    ];

    bind = [
      # Applications

      (bind "${mod} + Return" "hl.dsp.exec_raw(\"kitty -1\")") # so the single instance actually works
      (exec "${mod} + SHIFT + R" "hyprctl reload")
      (exec "${mod} + D" launcher-cmd)
      (exec "${mod} + SHIFT + D" "noctalia msg window-switcher")
      (exec "${mod} + SHIFT + P" lock-cmd)
      (exec "${mod} + CONTROL + X" power-cmd)

      # Window management
      (bind "${mod} + Q" "hl.dsp.window.close()")
      (bind "${mod} + Space" "hl.dsp.window.float()")
      (bind "${mod} + C" "hl.dsp.window.pseudo()")
      (bind "${mod} + F" "hl.dsp.window.fullscreen()")

      # Screenshots
      (exec "Print" "noctalia msg screenshot-fullscreen")
      (exec "SUPER + SHIFT + S" "noctalia msg screenshot-region")
      (exec "SHIFT + Print" "noctalia msg screenshot-annotate")

      # Media / utilities
      (exec "${mod} + P" "playerctl play-pause")
      (exec "XF86Calculator" "qalculate-gtk")

      # Groups
      (group "${mod} + SHIFT + V" "toggle()")
      (group "${mod} + N" "next()")
      (group "${mod} + SHIFT + N" "prev()")

      # Workspace cycling
      (bind "${mod} + Tab" "hl.dsp.focus({ workspace = \"e+1\" })")
      (bind "${mod} + SHIFT + Tab" "hl.dsp.focus({ workspace = \"e-1\" })")

      # Monitors
      (monitor "period" "r")
      (monitor "comma" "l")
      (moveMonitor "period" "r")
      (moveMonitor "comma" "l")

      # Focus
      (focus "Left" "l")
      (focus "Right" "r")
      (focus "Up" "u")
      (focus "Down" "d")
      (focus "H" "l")
      (focus "L" "r")
      (focus "K" "u")
      (focus "J" "d")

      # Move
      (move "Left" "l")
      (move "Right" "r")
      (move "Up" "u")
      (move "Down" "d")
      (move "H" "l")
      (move "L" "r")
      (move "K" "u")
      (move "J" "d")

      # Mouse
      (bind "${mod} + mouse:272" "hl.dsp.window.drag()")
      (bind "${mod} + mouse:273" "hl.dsp.window.resize()")
    ]
    ++ workspaces;
  };
}
