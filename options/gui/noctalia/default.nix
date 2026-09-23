{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.custom.programs.quickshell;
  cfg' = config.custom.programs;

  ipc = "noctalia msg";
  mkLua = lib.generators.mkLuaInline;
  bindWith = key: luaExpr: {
    _args = [
      key
      (mkLua luaExpr)
    ];
  };
  dsp = key: call: bindWith key "hl.dsp.${call}";
  exec = key: cmd: dsp key "exec_cmd(\"${cmd}\")";

  inherit (config.custom) username enableHM;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;
in
{
  options.custom.programs.quickshell = {
    #NOTE: needs HM
    enable = mkEnableOption "quickshell";
  };

  config = mkIf (cfg.enable && enableHM) {
    custom.programs.launcher = "${ipc} panel-toggle launcher";
    custom.programs.locker = "${ipc} session lock";
    custom.programs.power_menu = "${ipc} panel-toggle session";

    environment.sessionVariables = {
      QS_ICON_THEME = "Papirus-Dark";
    };

    home-manager.users.${username} =
      {
        config,
        pkgs,
        ...
      }:
      {
        imports = [
          inputs.noctalia.homeModules.default
        ];

        home.packages = with pkgs; [
          ddcutil
        ];
        programs.noctalia.enable = true;

        xdg.configFile."noctalia/settings.toml".source =
          config.lib.file.mkOutOfStoreSymlink "/home/${username}/flake/options/gui/quickshell/settings.toml";

        wayland.windowManager.hyprland.extraConfig = ''
          local noctalia = require("noctalia")
          noctalia.apply_theme()

        '';
        wayland.windowManager.hyprland.settings = {
          bind = [
            (exec "XF86AudioRaiseVolume" "${ipc} volume-up")
            (exec "XF86AudioLowerVolume" "${ipc} volume-down")
            (exec "XF86AudioMute" "${ipc} volume-mute")
            (exec "ALT + b" "${ipc} bar-toggle")

            (exec "XF86MonBrightnessUp" "${ipc} brightness-up")
            (exec "XF86MonBrightnessDown" "${ipc} brightness-down")
          ];

          on = {
            _args = [
              "hyprland.start"
              (lib.generators.mkLuaInline ''
                function()
                  hl.exec_cmd("noctalia")
                end
              '')
            ];
          };
        };

        xdg.configFile."noctalia/user-templates.toml".text = ''
          [theme.templates.user.neovim]
          input_path = "~/.config/nvim/lua/theme-template.lua"
          output_path = "~/.config/nvim/lua/theme.lua"
          post_hook = "pkill -SIGUSR1 nvim"
        '';

        #gtk
        home.pointerCursor = {
          enable = true;
          gtk.enable = true;
          x11.enable = true;
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Classic";
          size = 16;
        };
        gtk = {
          enable = true;
          cursorTheme = {
            name = "Bibata-Modern-Classic";
            package = pkgs.bibata-cursors;
          };
          iconTheme = {
            package = pkgs.papirus-icon-theme;
            name = "Papirus-Dark";
          };
          gtk4.theme = config.gtk.theme;
          theme = {
            name = "adw-gtk3";
            package = pkgs.adw-gtk3;
          };
        };

        # qt
        qt = {
          enable = true;

          platformTheme.name = "qtct";

          style.name = "noctalia";
        };

        xdg.configFile."qt6ct/qt6ct.conf".text = ''
          [Appearance]
          color_scheme_path=~/.config/qt6ct/colors/noctalia.conf
          custom_palette=true
        '';

        # kitty
        programs.kitty.extraConfig = mkIf cfg'.kitty.enable "include ~/.config/kitty/themes/noctalia.conf";
      };
  };
}
