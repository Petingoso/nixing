{
  pkgs,
  osConfig,
  ...
}: let
  launcher-cmd = osConfig.custom.programs.launcher;
  lock-cmd = osConfig.custom.programs.locker;
  power-cmd = osConfig.custom.programs.power_menu;
  mod = "ALT";
in {
  home.packages = with pkgs; [
    playerctl
    qalculate-gtk
    hyprshot
  ];
  wayland.windowManager.hyprland.settings = {
    bindm = [
      "${mod},mouse:272,movewindow"
      "${mod},mouse:273,resizewindow"
    ];
    bind =
      [
        "${mod} CONTROL, Q ,exit,"
        "${mod} SHIFT, R, exec, hyprctl reload"
        "${mod}, Space, togglefloating"
        "${mod}, Q, killactive"
        "${mod}, C, pseudo,"
        "${mod}, F, fullscreen,"

        "${mod}, Return, exec, kitty -1"

        ",Print,exec, hyprshot -m output -o ~/Pictures/SS/ -z"

        "SUPERSHIFT,S,exec, hyprshot -m region -z --clipboard-only"

        "${mod}, D, exec, ${launcher-cmd}"
        "${mod} SHIFT, P, exec, ${lock-cmd}"
        "${mod} CONTROL, X, exec, ${power-cmd}"

        # "${mod}, V, togglesplit"
        "${mod} SHIFT, V, togglegroup"
        "${mod}, N ,changegroupactive,f"
        "${mod} SHIFT,N,changegroupactive,b"
        "${mod}, S,layoutmsg,swapwithmaster"

        "${mod},P,exec,playerctl play-pause"
        # ",XF86AudioRaiseVolume,exec,amixer set Master 5%+"
        # ",XF86AudioLowerVolume,exec,amixer set Master 5%-"
        # ",XF86AudioMute,exec,amixer  set Master 1+ toggle"
        ",XF86Calculator,exec,qalculate-gtk"

        "${mod}, tab, workspace, +1"
        "${mod} SHIFT, tab, workspace, -1"
        "${mod}, period, focusmonitor,r"
        "${mod}, comma, focusmonitor,l"
        "${mod} SHIFT,period,movewindow,mon:r"
        "${mod} SHIFT,comma,movewindow,mon:l"

        # "${mod} CONTROL,left,splitratio,-0.1"
        # "${mod} CONTROL,right,splitratio,+0.1"
        # "${mod} CONTROL,h,splitratio,-0.1"
        # "${mod} CONTROL,l,splitratio,+0.1"

        "${mod}, left, movefocus, l"
        "${mod}, right, movefocus, r"
        "${mod}, up, movefocus, u"
        "${mod}, down, movefocus, d"

        "${mod}, h, movefocus, l"
        "${mod}, l, movefocus, r"
        "${mod}, k, movefocus, u"
        "${mod}, j, movefocus, d"

        "${mod} SHIFT, left, movewindow, l"
        "${mod} SHIFT, right, movewindow, r"
        "${mod} SHIFT, up, movewindow, u"
        "${mod} SHIFT, down, movewindow, d"

        "${mod} SHIFT, h, movewindow, l"
        "${mod} SHIFT, l, movewindow, r"
        "${mod} SHIFT, k, movewindow, u"
        "${mod} SHIFT, j, movewindow, d"
      ]
      ++ (
        # workspaces
        # binds ${mod} + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (
          builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in [
              "${mod}, ${ws}, workspace, ${toString (x + 1)}"
              "${mod} SHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
            ]
          )
          10
        )
      );
  };
}
