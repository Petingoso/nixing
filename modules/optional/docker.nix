{config, ...}: let
  inherit (config.mystuff.other.system) username;
in {
virtualisation.docker = {
  # Consider disabling the system wide Docker daemon
  enable = false;

  rootless = {
    enable = true;
    setSocketVariable = true;
    # Optionally customize rootless Docker daemon settings
    # daemon.settings = {
    #   dns = [ "1.1.1.1" "8.8.8.8" ];
    #   registry-mirrors = [ "https://mirror.gcr.io" ];
    # };
  };
};

  # virtualisation.docker.enable = true;
  # users.extraGroups.docker.members = ["${username}"];
  # virtualisation.docker.storageDriver = "btrfs";
}
