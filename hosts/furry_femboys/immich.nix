{config, ...}: let
  system = "aarch64-linux";

  # Pinning nixpkgs to a specific commit
  pinnedNixpkgs = import (fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/56632eb784483ae5e747a54ff5298f0f4c219d1b.tar.gz";
    sha256 = "sha256:076k2ng8l1mjx5bcv22ypr54ja9aax59w99g0m66jws62k8di1nf";
  }) {inherit system;};
  # while is broken https://github.com/nixos/nixpkgs/issues/418799
in {
  services.immich = {
    enable = true;
    port = 8400;
    package = pinnedNixpkgs.pkgs.immich;
    # environment = {};
    mediaLocation = "/data/immich";
    accelerationDevices = null;
    machine-learning.enable = true;
  };
}
