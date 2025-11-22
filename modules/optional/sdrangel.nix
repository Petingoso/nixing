{
  config,
  inputs,
  ...
}: let
  inherit (config.mystuff.other.system) username;
in {
  # environment.systemPackages = [ pkgs.sdrangel];
  hardware.rtl-sdr.enable = true;
  users.users.${username} = {
    extraGroups = ["plugdev"];
  };
  imports = [inputs.nix-flatpak.nixosModules.nix-flatpak];
  services.flatpak.enable = true;
  services.flatpak.packages = [
    "org.sdrangel.SDRangel"
  ];
}
