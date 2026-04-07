{
  lib,
  self,
  ...
}: let
  inherit (lib.lists) map;
in {
  imports = map (name: "${self}/modules/optional/${name}") [
    "cpu/amd.nix"
    "hyprland/default.nix"

    "auto-update.nix"
    # "afs.nix"
    "direnv.nix"
    "docker.nix"
    "fcitx.nix"
    "kleopatra.nix"
    "libvirt.nix"
    "nix-alien.nix"
    "opensnitch.nix"
    "wayland.nix"
  ];
}
