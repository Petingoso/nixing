let
  wired_host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILwPyI9fCiJlTMfvqwuKR93H39qc51vLz5TTeRoTpCAy root@Wired";
  user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDMGkaggPzHcfdwitao9/yK3XBDCsAsRRWBQLr/mwSs5";

  furry_femboys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMGED4p6L2EYc8SY70XRF4TYM85/KDONH77vz/SFBSWc pet@furryfemboys"
  ];

  personal = [
    user
    wired_host
  ];

  server = [
    user
  ]
  ++ furry_femboys;

  media = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICYiuCHjX9Dmq69WoAn7EfgovnFLv0VhjL7BSTYQcFa7 dtc@apollo"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINlaWu32ANU+sWFcwKrPlqD/oW3lC3/hrA1Z3+ubuh5A dtc@bacchus"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICmAw3MrBc3MERcNBkerJwfh9fmfD1OCeYnLVJVxs2Rs dtc@xiaomi11tpro"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICG5lKQD5jhYAT7hOLLV/3nD6IJ6BG/2OKIl/Ry5lRDg ft@geoff"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKwWOg8uO5Nhon69IDx/mXvtTzG3jmvBVRhY2nEElVHe pet@teto"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIvtyfLtvywk+T7MTIfsoYJxUnVbuZgt8CcHoW49e8UU pet@live"
  ];
in
{
  "ENV-mediafederation.age".publicKeys = personal ++ media;
  "caddy-env.age".publicKeys = server;
  "cloudflare.age".publicKeys = server;
  "fail2ban-env.age".publicKeys = server;
  "grafana-env.age".publicKeys = server;
  "gramps-env.age".publicKeys = server;
  "lanraragi.age".publicKeys = server;
  "searx.age".publicKeys = server;
  "searx-prometheus.age".publicKeys = server;
  "vaultwarden-token.age".publicKeys = server;
  "wireguard.age".publicKeys = personal;
  "znc.nix.age".publicKeys = personal;

  "syncthing-Wired-cert.age".publicKeys = [ wired_host ];
  "syncthing-Wired-key.age".publicKeys = [ wired_host ];
  #"syncthing-HeadEmpty-cert.age" = HeadEmpty;
  #syncthing-HeadEmpty-key.age" = HeadEmpty;
}
