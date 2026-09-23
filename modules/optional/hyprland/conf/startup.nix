{ pkgs, lib, ... }:
{
  wayland.windowManager.hyprland.settings = {
    on = {
      _args = [
        "hyprland.start"
        (lib.generators.mkLuaInline "function()
    hl.exec_cmd(\"${pkgs.kdePackages.kdeconnect-kde}/bin/kdeconnect-indicator\")
    hl.exec_cmd(\"fcitx-5\")
    hl.exec_cmd(\"noctalia\")
    hl.exec_cmd(\"${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard regular --reconnect-tries 1 \")
    end
    ")
      ];
    };
    #exec-once = [
      #"opensnitch-ui"
    #];
  };
}
