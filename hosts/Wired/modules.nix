{lib,self, ...}: let
  inherit (lib.lists) map;
in {
  imports = map (name: "${self}/modules/optional/${name}") [
    "cpu/amd.nix"
    "hyprland/default.nix"
    # "scripts/default.nix"
    "afs.nix"
    "btrfs-maint.nix"
    "direnv.nix"
    "docker.nix"
    "dualsense.nix"
    "fcitx.nix"
    # "kleopatra.nix"
    "libvirt.nix"
    # "nix-alien.nix"
    "opensnitch.nix"
    "opentabletdriver.nix"
    # # "pcloud.nix"
    "piper.nix"
    # # "podman.nix"
    "wayland.nix"
    "wireguard.nix"
  ];
}

