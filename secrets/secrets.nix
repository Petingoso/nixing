let
  Wired_user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDMGkaggPzHcfdwitao9/yK3XBDCsAsRRWBQLr/mwSs5";
  # Wired_host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAGwssK9tuGPxhbcCypQjm0NBJ5JwS+iG1IIfiAkgzVH";

  HeadEmpty_user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDMGkaggPzHcfdwitao9/yK3XBDCsAsRRWBQLr/mwSs5";
  # HeadEmpty_host = "";

  Wired = [Wired_user];
  HeadEmpty = [HeadEmpty_user];

  rnl = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKwWOg8uO5Nhon69IDx/mXvtTzG3jmvBVRhY2nEElVHe"];
in {
  "test.age".publicKeys = Wired ++ HeadEmpty;
  "wireguard.age".publicKeys = Wired ++ HeadEmpty;
}
