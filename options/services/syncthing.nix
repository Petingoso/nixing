{
  config,
  lib,
  ...
}: let
  cfg = config.custom.services.syncthing;
  inherit (config.custom) username;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) str;
in {
  options.custom.services.syncthing = {
    enable = mkEnableOption "syncthing";
    username = mkOption {
      type = str;
      description = "user to run + will have sync paths";
      default = username;
    };
    hostName = mkOption {
      description = "hostName. So agenix will substitute";
      type = str;
    };
    confDir = mkOption {
      type = str;
      description = "where configs will be stored";
      default = "/home/${cfg.username}/.config/syncthing";
    };
    dataDir = mkOption {
      type = str;
      description = "where data will be stored";
      default = "/home/${cfg.username}/.local/share/syncthing";
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets = {
      syncthing-cert = {
        file = ../../secrets/syncthing-${cfg.hostName}-cert.age;
        owner = "${cfg.username}";
        group = "users";
      };
      syncthing-key = {
        file = ../../secrets/syncthing-${cfg.hostName}-key.age;
        owner = "${cfg.username}";
        group = "users";
      };
    };

    services.syncthing = {
      enable = true;
      openDefaultPorts = true;

      user = "${cfg.username}";
      group = "users";

      configDir = cfg.confDir;
      dataDir = cfg.dataDir;

      cert = config.age.secrets.syncthing-cert.path;
      key = config.age.secrets.syncthing-key.path;

      settings = {
        devices = {
          "server" = {
            id = "SS6AYGS-OMHE5F3-VVTK74G-Z2S2GDA-HNA5KW3-6QPA6L7-6WD7T4B-FEPGUAL";
          };
          "HeadEmpty" = {
            id = "WGFRXWA-HAZYELG-IAJ4ZW7-QPGUDB2-MNM6C72-4R3UTUG-BKKHLVM-MMOQ4QY";
          };
          "Wired" = {
            id = "HRPTCYA-BMQ6A5D-TOJ3JGS-EFY6UDC-GBNYRPU-AYR3EZA-ORR7ZFQ-VEJYBAR";
          };
        };

        folders = {
          "Documents" = {
            path = "/home/${cfg.username}/Documents";
            devices = [
              "server"
              "HeadEmpty"
              "Wired"
            ];
          };
          "Sync" = {
            path = "/home/${cfg.username}/Sync";
            devices = [
              "server"
              "HeadEmpty"
              "Wired"
            ];
            ignorePerms = false;
          };
        };
      };
    };
  };
}
