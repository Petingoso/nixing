{
  pkgs,
  lib,
  config,
  ...
}: {
  options.mystuff.programs = {
    ranger.enable = lib.mkEnableOption "ranger";
  };
  config = lib.mkIf config.mystuff.programs.ranger.enable {
    home-manager.users.${config.mystuff.other.system.username} = {
      home.packages = [pkgs.ranger pkgs.xdragon];
      xdg.configFile = {
        "ranger/commands.py".source = ./conf/commands.py;
        "ranger/rc.conf".source = ./conf/rc.conf;
        "ranger/rifle.conf".source = ./conf/rifle.conf;
        "ranger/plugins/ranger_archives".source = fetchGit {
          url = "https://github.com/maximtrp/ranger-archives";
          rev = "62783ddb84c8fd25eba1be1607d3a47e8efe8b31";
        };
        "ranger/plugins/ranger_devicons".source = fetchGit {
          url = "https://github.com/alexanderjeurissen/ranger_devicons";
          rev = "2c3c19dffb4238d01c74515c9eed5088066db243";
        };
      };
    };
  };
}
