{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mystuff.programs.mpv;
  inherit (config.mystuff.other.system) username;

  inherit (lib.attrsets) attrValues;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) nullOr str;
in {
  options.mystuff.programs.mpv = {
    enable = mkEnableOption "mpv";
    gpu = mkOption {
      description = "gpu used to render videos played through mpv";
      type = nullOr str;
      default = null;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.mpv = {
        enable = true;
        config = {
          vo = "gpu-next";
          hwdec = "auto";
          gpu-api = "vulkan";
          vulkan-device = mkIf (cfg.gpu != null) cfg.gpu;
          # volume = 50;
          # osc = "no";
          # osd-bar = "no";
          # border = "no";
        };
        scripts = attrValues {
          inherit
            (pkgs.mpvScripts)
            mpris
            thumbfast
            # sponsorblock
            
            # uosc
            
            ;
        };
      };
    };
  };
}
