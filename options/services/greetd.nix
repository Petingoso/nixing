{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.services.greetd;
  inherit (config.custom) username;

  inherit (lib.meta) getExe;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.strings) concatStringsSep;
  inherit (lib.types) listOf str;

  cage = getExe pkgs.cage;
  greeter = getExe pkgs.${cfg.greeter};
in {
  options.custom.services.greetd = {
    enable = mkEnableOption "greetd";
    cage = mkEnableOption "cage";
    greeter = mkOption {
      description = "greetd frontend to use";
      type = str;
    };
    environments = mkOption {
      description = "/etc/greetd/environments as list of strings";
      type = listOf str;
    };
  };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings.default_session = {
        command =
          if cfg.cage
          then "${cage} -s -- ${greeter}"
          else "${greeter} --cmd ${builtins.elemAt cfg.environments 0 }";

        user = username;
      };
    };

    environment.etc."greetd/environments".text = concatStringsSep "\n" (
      cfg.environments
      ++ [
        config.custom.programs.shell
        "reboot"
        "shutdown now"
      ]
    );
  };
}
