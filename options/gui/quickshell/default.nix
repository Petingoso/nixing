{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.custom.programs.quickshell;
  cfg' = config.custom.programs;

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
    custom.programs.launcher = "noctalia-shell ipc call launcher toggle";
    custom.programs.locker = "noctalia-shell ipc call lockScreen lock";
    custom.programs.power_menu = "noctalia-shell ipc call sessionMenu toggle";

    environment.sessionVariables = {
      QS_ICON_THEME="Papirus-Dark";
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

        programs.noctalia-shell.enable = true;

        xdg.configFile."noctalia/settings.json".source =
          config.lib.file.mkOutOfStoreSymlink "/home/${username}/flake/options/gui/quickshell/settings.json";

        wayland.windowManager.hyprland.settings = {
          source = "~/.config/hypr/noctalia/noctalia-colors.conf";
          exec-once = [ "noctalia-shell" ];
        };

        xdg.configFile."noctalia/user-templates.toml".text = ''
          [config]

          [templates]

          [templates.nvim-base16]
          input_path = "~/.config/nvim/lua/theme-template.lua"
          output_path = "~/.config/nvim/lua/theme.lua"
          post_hook = 'pkill -SIGUSR1 nvim'
        '';

        #gtk
        home.pointerCursor = {
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
          theme = {
            name = "adw-gtk3";
            package = pkgs.adw-gtk3;
          };
        };

        # qt
        qt = {
          enable = true;

          platformTheme = "qtct";

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
