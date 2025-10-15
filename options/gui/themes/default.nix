{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.theme_switching;
  cfg' = config.mystuff.programs;
  inherit (config.custom) username enableHM;

  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;
  xdg = config.home-manager.users.${username}.xdg;
  themePath = "$HOME/.cache/";
  matugenCommand = ''
    ${config.programs.matugen.package}/bin/matugen image "${themePath}/wallpaper" \
    --config ${config.programs.matugen.theme.files}/matugen-config.toml
  '';

  setupScript = ''
    #find the first wallpaper (placeholder)
    wallpaper=$(find ${xdg.configHome}/wallpaper -type f -not -wholename '*git*' | head -1)

    cp wallpaper ${themePath}/wallpaper

    ${matugenCommand}
  '';
in
{
  options.theme_switching = {
    enable = mkEnableOption "Activate the facilities for mutagen themes";
  };

  config = mkIf cfg.enable {
    imports = [
      inputs.matugen.nixosModules.default
    ];

    home-manager.users.${username} = mkIf (enableHM && cfg.enable) {
      # templates
      programs.matugen = {
        enable = true;
        templates = {
          hyprland = {
            input_path = ./matugen-themes/templates/hyprland-colors.conf;
            output_path = "${themePath}/hypr.conf";
          };
          kitty = {
            input_path = ./matugen-themes/templates/kitty-colors.conf;
            output_path = "${themePath}/kitty.conf";
            post_hook = "pkill -SIGUSR1 kitty";
          };
          gtk3 = {
            input_path = ./matugen-themes/templates/gtk-colors.css;
            output_path = "${xdg.configHome}/gtk-3.0/gtk.css";
            post_hook = "gsettings set org.gnome.desktop.interface gtk-theme " "; gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3-{{mode}}"; # TODO: make this cleaner
          };
          gtk4 = {
            input_path = ./matugen-themes/templates/gtk-colors.css;
            output_path = "${xdg.configHome}/gtk-4.0/gtk.css";
          };
          qt = {
            input_path = ./matugen-themes/templates/qtct-colors.conf;
            output_path = "${themePath}/qt.conf";
          };
          nvim = {
            input_path = ./matugen-themes/templates/nvim.lua;
            output_path = "${themePath}/nvim.lua";
          };
        };
      };

      # TODO:
      # quickshell
      # vscode

      # nvim
      xdg.configFile."nvim/lua/core/init.lua" = cfg'.neovim-config.enable (
        lib.strings.concatStrings [
          (builtins.readFile ../../tui/neovim/conf/lua/core/init.lua)
          ''
            #HOME
            pcall(dofile, "${themePath}/nvim.lua")
          ''
        ]
      );

      # qt
      xdg.configFile."qt6ct/qt6ct.conf" = ''
        [Appearance]
        color_scheme_path=${themePath}/qt.conf
        custom_palette=true
      '';

      # kitty
      programs.kitty.extraConfig = mkIf cfg'.kitty.enable "include ${themePath}/kitty.conf";

      # Hyprland
      wayland.windowManager.hyprland.settings = mkIf cfg'.hyprland.enable {
        source = "${themePath}/hypr.conf";
      };

      systemd.user.services.theme-setup = {
        Unit = {
          Description = "Setup theme files for programs";
        };
        wantedBy = [ "graphical.target" ];
        script = setupScript;
        reload = matugenCommand;
      };
    };
  };
}
