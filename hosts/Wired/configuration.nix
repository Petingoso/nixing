{config, ...}: let
  inherit (config.mystuff.other.system) username;
in {
  programs.kdeconnect.enable = true;

  mystuff = {
    other.home-manager.enable = true;
    programs = {
      git = {
        enable = true;
        defaultBranch = "master";
      };
      zsh = {
        enable = true;
        zinit.enable = true;
      };
      nh.enable = true;
      nh.flake = "/home/${username}/flake";
      firefox-config.enable = true;
      kitty.enable = true;
      rofi.enable = true;
      swaync.enable = true;
      waybar.enable = true;
      mpv.enable = true;
      neovim-config.enable = true;
      ranger.enable = true;
    };
    services = {
      networkmanager.enable = true;
    };
    gtk.enable = true;
    qt.enable = true;
  };

  system.stateVersion = "23.11";
}
