{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.services.syncthing;
  inherit (config.custom) username;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) str;
in
{
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

    documentsPath = mkOption {
      type = str;
      description = "path to Documents";
      default = "/home/${cfg.username}/Documents";
    };

    syncPath = mkOption {
      type = str;
      description = "path to Sync";
      default = "/home/${cfg.username}/Sync";
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
            id = "DUOZC7B-7SS2E45-D426FJH-TSSROG6-PWQZP4L-HN4VH52-RRXQAB4-X4262AD";
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
            path = cfg.documentsPath;
            devices = [
              "server"
              "HeadEmpty"
              "Wired"
            ];
          };
          "Sync" = {
            path = cfg.syncPath;
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
