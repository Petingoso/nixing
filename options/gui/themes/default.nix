{
  lib,
  pkgs,
  config,
  self,
  ...
}: {
  options.mystuff = {
    gtk.enable = lib.mkEnableOption "gtk";
    qt.enable = lib.mkEnableOption "qt";
  };

  config = lib.mkMerge [
    (lib.mkIf config.mystuff.gtk.enable {
      programs.dconf.enable = true;
      environment.sessionVariables = {
        GSETTINGS_SCHEMA_DIR = "${pkgs.gnome.nixos-gsettings-overrides}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/";
        XCURSOR_THEME = "Adwaita";
      };
      home-manager.users.${config.mystuff.other.system.username} = {
        gtk.iconTheme = {
          package = pkgs.papirus-icon-theme;
          name = "Papirus-Dark";
        };

        home.packages = with pkgs; [
          adwaita-icon-theme
          gnome.nixos-gsettings-overrides
          nordic
          (callPackage "${self}/pkgs/everforest.nix" {})
          (callPackage "${self}/pkgs/gruvbox.nix" {})
          (callPackage "${self}/pkgs/oomox-srcery.nix" {})
          (callPackage "${self}/pkgs/tokyonight.nix" {})
          (callPackage "${self}/pkgs/rose-pine.nix" {})
          (catppuccin-gtk.override
            {
              accents = ["red"];
              variant = "macchiato";
            })
          numix-solarized-gtk-theme
          papirus-icon-theme
        ];
      };
    })

    (lib.mkIf
      config.mystuff.qt.enable
      {
        home-manager.users.${config.mystuff.other.system.username} = {
          qt = {
            enable = true;
            platformTheme.name = "qtct";
            style.name = "kvantum";
          };
          home.packages = with pkgs; [libsForQt5.qtstyleplugin-kvantum];
        };
      })
  ];
}
