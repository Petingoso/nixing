{inputs, ...}: {
  imports = [inputs.nix-flatpak.nixosModules.nix-flatpak];
  services.flatpak.enable = true;
  services.flatpak.packages = [
    "com.valvesoftware.SteamLink"
  ];
}
