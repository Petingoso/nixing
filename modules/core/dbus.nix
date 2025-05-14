_: {
  services.dbus = {
    enable = true;
    implementation = "broker";
  };

  users.users.root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG7foe85vNDLm0vyVVugR8ThC1VjHuAtqAQ/K2AAVE9r rg"
      ];
}
