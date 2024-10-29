{osConfig, ...}: {
  wayland.windowManager.hyprland.settings.env = [
    "CLUTTER_BACKEND,wayland"
    "XDG_SESSION_TYPE,wayland"
    "MOZ_ENABLE_WAYLAND,1"

    "WLR_NO_HARDWARE_CURSORS,1"
    "WLR_BACKEND,vulkan"
    "GDK_BACKEND,wayland"

    "QT_IM_MODULE,fcitx"
    "GLFW_IM_MODULE,ibus"
    "SDL_IM_MODULE,fcitx"

    "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
    "QT_QPA_PLATFORM,wayland"
    "QT_QPA_PLATFORMTHEME,kvantum"
    "QT_STYLE_OVERRIDE,kvantum"

    "LC_ALL,C"
    "FLAKE,/home/${osConfig.mystuff.other.system.username}/flake"
  ];
}
