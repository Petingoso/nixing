{ config, pkgs, ... }:

let
  customLinx = pkgs.callPackage ./linx.nix {};

  linxConfig = pkgs.writeText "config.toml" ''
    bind = '0.0.0.0:6900'
    files-path = '/var/lib/linx-server/files'
    meta-path = '/var/lib/linx-server/meta'
    site-name = 'Linx'
    site-url = 'https://bin.undertale.uk/'
    max-size = '4 GiB'
    allow-hotlink = true
    force-random-filename = true
    keep-original-filename = true

    max-expiry = '720h'
    cleanup-every = '1h'


    [header]
    real-ip = true
    referrer-policy = 'same-origin'
    x-frame-options = ""
  '';
in {

  fileSystems."/var/lib/linx-server" = {
    fsType = "none";
    device = "/data/linx-server";
    options = [ "bind" ];
  };

  age.secrets.linx-admin-keys.file = ../../secrets/linx.age;

  systemd.services.linx-server = {
    description = "Linx-server Service";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    
    serviceConfig = {
      ExecStart = "${customLinx}/bin/linx-server --config=${linxConfig}";
      StateDirectory = "linx-server";
      Restart = "always";
    };
  };
}
