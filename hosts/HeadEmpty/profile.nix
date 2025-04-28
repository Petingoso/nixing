{lib, ...}: let
  inherit (lib.lists) map;
in {
  imports = map (name: "${../../modules/optional/${name}}") [
    "cpu/intel.nix"
    "hyprland/default.nix"
    "scripts/default.nix"
    "afs.nix"
    "direnv.nix"
    "fcitx.nix"
    "kleopatra.nix"
    "nix-alien.nix"
    "libvirt.nix"
    "opensnitch.nix"
    "piper.nix"
    "wayland.nix"
    "wireguard.nix"
  ];
}
