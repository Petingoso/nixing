{...}: {
  wayland.windowManager.hyprland.settings.env = [
    "CLUTTER_BACKEND,wayland,x11,*"
    "MOZ_ENABLE_WAYLAND,1"
    "SDL_VIDEODRIVER,wayland"

    "WLR_BACKEND,vulkan"
    "GDK_BACKEND,wayland"

    "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
    "QT_QPA_PLATFORM,wayland;xcb"
    "QT_QPA_PLATFORMTHEME,qt6ct"
    # "QT_STYLE_OVERRIDE,qt6ct"

    "XDG_CURRENT_DESKTOP,Hyprland"
    "XDG_SESSION_TYPE,wayland"
    "XDG_SESSION_DESKTOP,Hyprland"
  ];
}
