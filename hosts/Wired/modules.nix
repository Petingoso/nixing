{lib,self, ...}: let
  inherit (lib.lists) map;
in {
  imports = map (name: "${self}/modules/optional/${name}") [
    # "cpu/amd.nix"
    # "btrfs-maint.nix"
    # "hyprland/default.nix"
    # "scripts/default.nix"
    # "afs.nix"
    # "direnv.nix"
    # #"docker.nix"
    # "dualsense.nix"
    # "fcitx.nix"
    # "kleopatra.nix"
    # "nix-alien.nix"
    # # "libvirt.nix"
    # "opensnitch.nix"
    # "opentabletdriver.nix"
    # # "pcloud.nix"
    # # "piper.nix"
    # # "podman.nix"
    # "wayland.nix"
    # "wireguard.nix"
  ];
}

