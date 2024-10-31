{pkgs, ...}: {
  wayland.windowManager.hyprland.settings = {
    exec = ["pkill waybar;waybar &"];
    exec-once = [
      "GDK_BACKEND=x11 pcloud"
      "${pkgs.plasma5Packages.kdeconnect-kde}/libexec/kdeconnectd"

      "${pkgs.swaynotificationcenter}"
      "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
      "fcitx5"
      "opensnitch-ui"
      "${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard regular --reconnect-tries 1 "
    ];
  };
}
