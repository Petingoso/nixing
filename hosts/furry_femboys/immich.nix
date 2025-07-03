{config, ...}: let
  system = "aarch64-linux";

  # Pinning nixpkgs to a specific commit
  pinnedNixpkgs = import (fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/56632eb784483ae5e747a54ff5298f0f4c219d1b.tar.gz";
    sha256 = "sha256:076k2ng8l1mjx5bcv22ypr54ja9aax59w99g0m66jws62k8di1nf";
  }) {inherit system;};
  # while is broken https://github.com/nixos/nixpkgs/issues/418799
in {
  environment.etc = {
    "fail2ban/filter.d/immich.conf".text = ''
      [Definition]
      failregex = Failed login attempt for user .* from ip address <HOST>
    '';
  };

  services.fail2ban.jails = {
    "immich" = ''
      enabled = true
      filter = immich
      findtime = 600
      maxretry = 4
      backend = systemd
      journalmatch = _SYSTEMD_UNIT=immich-server.service
    '';
  };

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
