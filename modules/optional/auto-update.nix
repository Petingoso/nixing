{ config, ... }:
let
  inherit (config.custom) username;
in
{
  #to prevent lack of space
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  system.autoUpgrade = {
    enable = true;
    dates = "02:00";
    flake = "/home/${username}/flake";
    flags = [
      "--commit-lock-file"
    ];
  };

  #https://wiki.nixos.org/wiki/Automatic_system_upgrades#Troubleshooting
  programs.git.config.safe.directory = config.system.autoUpgrade.flake;
}
