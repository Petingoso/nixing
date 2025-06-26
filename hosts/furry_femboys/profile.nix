{lib, ...}: let
  inherit (lib.lists) map;
in {
  imports =
    map (name: "${../../modules/optional/${name}}") [
    ];
}
