{ ... }: {
  wayland.windowManager.hyprland.settings.env = [
    {
      _args = [
        "CLUTTER_BACKEND"
        "wayland,x11,*"
      ];
    }
    {
      _args = [
        "MOZ_ENABLE_WAYLAND"
        "1"
      ];
    }
    {
      _args = [
        "SDL_VIDEODRIVER"
        "wayland"
      ];
    }
    {
      _args = [
        "WLR_BACKEND"
        "vulkan"
      ];
    }
    {
      _args = [
        "GDK_BACKEND"
        "wayland"
      ];
    }
    {
      _args = [
        "QT_WAYLAND_DISABLE_WINDOWDECORATION"
        "1"
      ];
    }
    {
      _args = [
        "QT_QPA_PLATFORM"
        "wayland;xcb"
      ];
    }
    {
      _args = [
        "QT_QPA_PLATFORMTHEME"
        "qt6ct"
      ];
    }
    # {
    #   _args = [ "QT_STYLE_OVERRIDE" "qt6ct" ];
    # }
    # {
    #   _args = [ "XDG_CURRENT_DESKTOP" "Hyprland" ];
    # }
    # {
    #   _args = [ "XDG_SESSION_TYPE" "wayland" ];
    # }
    # {
    #   _args = [ "XDG_SESSION_DESKTOP" "Hyprland" ];
    # }
  ];
}
