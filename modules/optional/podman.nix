{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.mystuff.other.system) username;
in {
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  users.users."${username}".extraGroups = ["podman"];
  # users.extraGroups.podman.members = ["${username}"];

  # Useful other development tools
  environment.systemPackages = with pkgs; [
    # dive # look into docker image layers
    podman-tui # status of containers in the terminal
    #docker-compose # start group of containers for dev
    podman-compose # start group of containers for dev
  ];

  # Add 'newuidmap' and 'sh' to the PATH for users' Systemd units.
  # Required for Rootless podman.
  systemd.user.extraConfig = ''
    DefaultEnvironment="PATH=/run/current-system/sw/bin:/run/wrappers/bin:${lib.makeBinPath [pkgs.bash]}"
  '';
}
