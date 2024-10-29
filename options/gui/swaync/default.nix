{
  pkgs,
  lib,
  config,
  ...
}: {
  options.mystuff.programs = {
    swaync.enable = lib.mkEnableOption "swaync";
  };

  config = lib.mkIf config.mystuff.programs.swaync.enable {
    home-manager.users.${config.mystuff.other.system.username} = {
      home.packages = [pkgs.swaynotificationcenter];
      xdg.configFile."swaync/config.json".source = ./config.json;
      xdg.configFile."swaync/style.css".source = ./style.css;
    };
  };
}
