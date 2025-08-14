{config, ...}: let
  inherit (config.custom) username;
in {
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = ["${username}"];
  # virtualisation.docker.storageDriver = "btrfs";
}
