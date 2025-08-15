{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.custom;
in {
  options.mystuff.programs = {
    #NOTE: needs HM
    ranger.enable = lib.mkEnableOption "ranger";
  };
  config = lib.mkIf (cfg.programs.ranger.enable && cfg.enableHM){
    home-manager.users.${cfg.username} = {
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
