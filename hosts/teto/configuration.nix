{config, ...}: let
  inherit (config.mystuff.other.system) username;
in {
  programs.kdeconnect.enable = true;
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

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
      mpv.enable = true;
      neovim-config.enable = true;
      vscode.enable = true;
      ranger.enable = true;
      vesktop.enable = true;
    };
    services = {
      networkmanager.enable = true;
      networkmanager.powersave = true;
    };
  };

  age.identityPaths = ["/home/${config.mystuff.other.system.username}/.ssh/id_ed25519"];
  system.stateVersion = "23.11";

  networking.firewall.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  users.users.petnix.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDMGkaggPzHcfdwitao9/yK3XBDCsAsRRWBQLr/mwSs5"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKwWOg8uO5Nhon69IDx/mXvtTzG3jmvBVRhY2nEElVHe"
  ];
}
