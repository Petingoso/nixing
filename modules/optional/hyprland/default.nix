{
  inputs,
  config,
  self,
  ...
}: {
  programs.hyprland.enable = true;
  home-manager.users.${config.mystuff.other.system.username} = {
    imports = [
      # inputs.hyprland.homeManagerModules.default
      "${self}/modules/optional/hyprland/hypridle.nix"
      "${self}/modules/optional/hyprland/hyprlock.nix"
      "${self}/modules/optional/hyprland/conf/binds.nix"
      "${self}/modules/optional/hyprland/conf/exports.nix"
      "${self}/modules/optional/hyprland/conf/settings.nix"
      "${self}/modules/optional/hyprland/conf/startup.nix"
    ];
    wayland.windowManager.hyprland.enable = true;
  };
}
