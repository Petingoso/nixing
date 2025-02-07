{config, ...}: let
  inherit (config.mystuff.other.system) username;
in {
  virtualisation.docker.enable = false;
  users.extraGroups.docker.members = ["${username}"];
  virtualisation.docker.storageDriver = "btrfs";
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
}
