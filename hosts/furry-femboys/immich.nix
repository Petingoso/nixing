{
  config,
  pkgs,
  inputs,
  ...
}:
let
  pkgs' = inputs.nixpkgs-unstable-latest.legacyPackages.${pkgs.system};
in
{
  users.users.immich = {
    home = "/var/lib/immich";
    createHome = true;
  };

  # services.postgresql.package = pkgs.postgresql_16;
  services.immich = {
    package = pkgs'.immich;
    enable = true;
    port = 8400;
    # environment = {};
    mediaLocation = "/data/immich";
    accelerationDevices = null;
    machine-learning.enable = true;
  };
}
