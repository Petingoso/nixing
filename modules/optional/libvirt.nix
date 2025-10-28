{
  config,
  pkgs,
  ...
}: let
  inherit (config.mystuff.other.system) username;
in {
  virtualisation = {
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      qemu = {
        # ovmf.enable = true;
        runAsRoot = false;
        # swtpm.enable = true;
      };
    };
    # spiceUSBRedirection.enable = true;
  };

  programs.virt-manager.enable = true;

  users.users.${username} = {
    extraGroups = ["libvirtd"];
  };
  environment.systemPackages = with pkgs; [
    spice
    spice-gtk
    spice-protocol
    virt-viewer
    #virtio-win
    #win-spice
  ];

  home-manager.users.${username} = {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };
}
