{lib, ...}: let
  inherit (lib.lists) map;
in {
  imports = map (name: "${../../modules/optional/${name}}") [
    "cpu/amd.nix"
    "scripts/default.nix"
    "afs.nix"
    "direnv.nix"
    "fcitx.nix"
    "kleopatra.nix"
    "nix-alien.nix"
    "opensnitch.nix"
    "wayland.nix"
    "wireguard.nix"
  ];
}
