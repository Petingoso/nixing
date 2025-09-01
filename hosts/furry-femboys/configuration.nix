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
    hashedPassword = "$6$T.zxcrxwu5lBt9hx$jh6sBk4Gi3hIDjMAom0ijRn.SwhbGNH51QOPPWQ3UsrgdVZKrL63SWVUEvihrmoTbt5chQ6w4Jr50yrQRb6Hp0";
  };

  networking.firewall.allowedTCPPorts = [2200];

  services.openssh = {
    enable = true;
    ports = [2200];
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "no";
  };

  system.autoUpgrade = {
    enable = false;
    flake = "path:/home/pet/flake";
    #NOTE: Impure for searx password workaround
    flags = ["--update-input" "nixpkgs-unstable-latest" "--no-write-lock-file" "-L" "--impure"];
    dates = "daily";
    allowReboot = true;
    rebootWindow.lower = "01:00";
    rebootWindow.upper = "03:00";
  };

  users.users.pet.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDMGkaggPzHcfdwitao9/yK3XBDCsAsRRWBQLr/mwSs5 petingavasco@protonmail.com"
  ];

  age.identityPaths = [ "/home/pet/.ssh/id_ed25519"];
  system.stateVersion = "25.11";
}
