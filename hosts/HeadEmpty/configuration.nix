{config, ...}: let
  username = "petnix";
in {
  custom.username = username;
  programs.kdeconnect.enable = true;

  custom = {
    programs = {
      git = {
        enable = true;
        defaultBranch = "master";
        userName = "Petingoso";
        userEmail = "petingavasco@protonmail.com";
      };
      zsh = {
        enable = true;
        zinit.enable = true;
      };
      nh.enable = true;
      nh.flake = "/home/${username}/flake";
      # firefox-config.enable = true;
      # kitty.enable = true;
      # rofi.enable = true;
      # swaync.enable = true;
      # waybar.enable = true;
      mpv.enable = true;
      vscode.enable = true;
      neovim-config.enable = true;
      ranger.enable = true;
      vesktop.enable = true;
    };
    services = {
      networkmanager.enable = true;
    };
    # gtk.enable = true;
    # qt.enable = true;
  };

  age.identityPaths = ["/home/${config.custom.username}/.ssh/id_ed25519"];

  system.stateVersion = "24.05";
}
