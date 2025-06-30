{
  config,
  pkgs,
  ...
}: {
  zramSwap.enable = true;

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  users.mutableUsers = false;
  users.users.pet = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
    password = "password";
  };

  networking.firewall.allowedTCPPorts = [2200];

  services.openssh = {
    enable = true;
    ports = [2200];
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "no";
  };

  services.fail2ban.enable = true;

  users.users.pet.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDMGkaggPzHcfdwitao9/yK3XBDCsAsRRWBQLr/mwSs5 petingavasco@protonmail.com"
  ];
  system.stateVersion = "25.11";
}
