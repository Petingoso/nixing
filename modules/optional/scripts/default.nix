{self, ...}: {
  imports = [
    "${self}/modules/optional/scripts/hyp.nix"
    "${self}/modules/optional/scripts/togglegaps.nix"
    "${self}/modules/optional/scripts/conservation.nix"
    "${self}/modules/optional/scripts/powermenu.nix"
    "${self}/modules/optional/scripts/theme_changer.nix"
  ];
}
