{lib, ...}: let
  inherit (lib.lists) map;
in {
  imports = map (name: "${../../modules/optional/${name}}") [
    "cpu/amd.nix"
    "hyprland/default.nix"
    "scripts/default.nix"
    # "afs.nix"
    "direnv.nix"
    "docker.nix"
    "fcitx.nix"
    "kleopatra.nix"
    # "libvirt.nix"
    # "opensnitch.nix"
    "opentabletdriver.nix"
    "pcloud.nix"
    "wayland.nix"
  ];
}
