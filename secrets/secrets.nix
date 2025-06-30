let
  Wired_user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDMGkaggPzHcfdwitao9/yK3XBDCsAsRRWBQLr/mwSs5";
  # Wired_host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAGwssK9tuGPxhbcCypQjm0NBJ5JwS+iG1IIfiAkgzVH";

  HeadEmpty_user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDMGkaggPzHcfdwitao9/yK3XBDCsAsRRWBQLr/mwSs5";
  # HeadEmpty_host = "";

  Wired = [Wired_user];
  HeadEmpty = [HeadEmpty_user];

  furry_femboys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMGED4p6L2EYc8SY70XRF4TYM85/KDONH77vz/SFBSWc pet@furryfemboys"];

  personal =  Wired ++ HeadEmpty ++ furry_femboys ;
in {
  "test.age".publicKeys = Wired ++ HeadEmpty;
  "wireguard.age".publicKeys = Wired ++ HeadEmpty;
  "cloudflare.age".publicKeys = personal;
  "caddy-env.age".publicKeys = personal;
  "vaultwarden-token.age".publicKeys = personal;
  "searx.age".publicKeys = personal;
  "gramps-env.age".publicKeys = personal;
}
