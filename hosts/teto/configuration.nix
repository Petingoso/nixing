{
  config,
  pkgs,
  ...
}: let
  inherit (config.custom) username;
in {

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services = {
    # xserver = {
    #   xkb.layout = "pt";
    # };
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = false;
    # displayManager.gdm.enable = true;
    # displayManager.gdm.enable = false;
    # desktopManager.gnome.enable = true;
    # displayManager.gdm.autoSuspend = false;
  };

  services.xserver.enable = true;

  environment.systemPackages = with pkgs.gnomeExtensions; [
    blur-my-shell
    auto-move-windows
    kimpanel
    space-bar
    tiling-shell
    mouse-follows-focus-2
  ];

  custom = {
    username = "petnix";
    programs = {
      git = {
        enable = true;
        defaultBranch = "master";
      };
      zsh = {
        enable = true;
        zinit.enable = true;
      };

      nh.enable = true;
      nh.clean.enable  = false; # auto-update.nix does it
      nh.flake = "/home/${username}/flake";

      quickshell.enable = true;
      firefox-config.enable = true;
      kitty.enable = true;
      mpv.enable = true;
      neovim-config.enable = true;
      vscode.enable = true;
      ranger.enable = true;
      vesktop.enable = true;
    };
    services = {
      networkmanager.enable = true;
      networkmanager.powersave = false;
      greetd = {
        enable = true;
        greeter = "tuigreet";
        cage = false;
      };
    };
  };

  age.identityPaths = ["/home/${username}/.ssh/id_ed25519"];
  system.stateVersion = "23.11";

  networking.firewall.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  services.fail2ban.enable = true;

  users.users.petnix.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDMGkaggPzHcfdwitao9/yK3XBDCsAsRRWBQLr/mwSs5" # main
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDEtMB91hKq09Ddo5gQAQKaPSVgTjynaB8gHLf0DTY7K"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF2iuDGZmmcpw7a4NTOvUSB2Op23hAUjgcObrBHp4G5Z"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQX+31Bs2b5ikdRnzKbWf85Llk9hEC0v0oMi0WDUf74XCrXmsnv/luI0yzMl4gI+edrEtWqvTQy6o/FKcEFqpVo9zWa4TQuJqTRdvHsL8v4Qb0u9kUEV3cUvUWCK61+cTD4/gkzFRjZ5lDDu+VfRuJ443vuagKpwDhvW8LpTI61vx5J/QAPK3HbabGcB50DZ50mV+dGOnYKhjvmrIdneaGtWfDoxSvXDqDNg/4DMMRZZ+Mal8LDUgDoZh/RoQwualWpeDTifuskDUqsE1RFJ8eAqW16M7uddn1O6/6Rjvi12Erep34XuQyLbR4y2GN+1ogn/aTCf4jtp9SpuYgeI54ucFafC4t4qD9CMdTdmfzirEcGwCtCmB4Bedcc28JcvvBzQLNt0hWY0fi10c33uAqKANj3O52FLps/RO+rsCy2zr+dNjZ/6wjSfqmnRTXBC5amex4+Z1adzR5BkheCnyUs8bhUhEIBN1UgH5an/hLXu67oi6pQb6kn/poj8pvFJs="
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPLLpKt6GEN56IzeYAD4W7Kta9P1C8q9ZXwbp4A4sjyG "
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFMCIkCUBTVVf73blq67XBAlKpnmCieAtVH60hjlfG/L "
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHXBp8JGSdNt6YjnvjvEDPw4cHjQTKKrtVfsrXbNeMdO "
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEgenlvZa+ccT/3CZeEL1gxjEnTdcXztt4607bLj9STc "
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB1pGwckKFCcb3yBOk6gS4s4pf0wW0ejzkfcxWBfUher "
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKK2wLwUKXIoXVtmQZ7I9ZEl4QM5b1cvk3teMiTLmvXx "
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKEEja9gFy3l2Yd8cbPlAIDjdkXZXTLdmfHYstN4wgF/ "
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN6Nz0rB03VJwTABh3R1IqDEvB6fifrkzcCIFpmQ1vMK "
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICfRQQBDQUGjuTP1kNVqKCF0PoppKxWzyYFU1ppYV4c5 "
  ];

  users.users.petnix.extraGroups = ["kvm"];
  # services.printing.enable = true;
  # services.samba.enable = true;
  # services.printing.drivers = [
  #   pkgs.gutenprintBin
  #   (pkgs.writeTextDir "share/cups/model/yourppd.ppd" (builtins.readFile ./xeroxdsi006.ppd))
  # ];
}
