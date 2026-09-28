{
  config,
  lib,
  ...
}: {
  config = {
    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
    programs.hyprland.enable = true;

    home-manager.users.${config.custom.username} = {
      imports = [
        #inputs.hyprland.homeManagerModules.default
        ./conf/binds.nix
        ./conf/exports.nix
        ./conf/startup.nix
        ./conf/settings.nix
      ];
      wayland.windowManager.hyprland.enable = true;
      wayland.windowManager.hyprland.configType = "lua";
    };
    custom = {
      services.greetd.environments = [
        "start-hyprland"
      ];
    };
  };
}
