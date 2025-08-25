let
  Wired_user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDMGkaggPzHcfdwitao9/yK3XBDCsAsRRWBQLr/mwSs5";
  # Wired_host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAGwssK9tuGPxhbcCypQjm0NBJ5JwS+iG1IIfiAkgzVH";

  HeadEmpty_user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDMGkaggPzHcfdwitao9/yK3XBDCsAsRRWBQLr/mwSs5";
  # HeadEmpty_host = "";

  Wired = [Wired_user];
  HeadEmpty = [HeadEmpty_user];

  furry_femboys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMGED4p6L2EYc8SY70XRF4TYM85/KDONH77vz/SFBSWc pet@furryfemboys"];

  personal = Wired ++ HeadEmpty ++ furry_femboys;


  media = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICYiuCHjX9Dmq69WoAn7EfgovnFLv0VhjL7BSTYQcFa7 dtc@apollo"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINlaWu32ANU+sWFcwKrPlqD/oW3lC3/hrA1Z3+ubuh5A dtc@bacchus"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICmAw3MrBc3MERcNBkerJwfh9fmfD1OCeYnLVJVxs2Rs dtc@xiaomi11tpro"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICG5lKQD5jhYAT7hOLLV/3nD6IJ6BG/2OKIl/Ry5lRDg ft@geoff"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKwWOg8uO5Nhon69IDx/mXvtTzG3jmvBVRhY2nEElVHe pet@teto"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIvtyfLtvywk+T7MTIfsoYJxUnVbuZgt8CcHoW49e8UU pet@live"

  ];
in {
  "test.age".publicKeys = Wired ++ HeadEmpty;
  "ENV-mediafederation.age".publicKeys = personal ++ media;
  "caddy-env.age".publicKeys = personal;
  "cloudflare.age".publicKeys = personal;
  "fail2ban-env.age".publicKeys = personal;
  "grafana-env.age".publicKeys = personal;
  "gramps-env.age".publicKeys = personal;
  "lanraragi.age".publicKeys = personal;
  "searx.age".publicKeys = personal;
  "searx-prometheus.age".publicKeys = personal;
  "vaultwarden-token.age".publicKeys = personal;
  "wireguard.age".publicKeys = Wired ++ HeadEmpty;
  "znc.nix.age".publicKeys = personal;
}
