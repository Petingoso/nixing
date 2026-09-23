{ config, ... }: {
  custom.services.syncthing = {
    enable = true;
    username = "syncthing";
    hostName = config.networking.hostName;
    confDir = "/data/syncthing-conf";
    dataDir = "/data/syncthing";
    documentsPath = "/data/syncthing/Documents";
    syncPath = "/data/syncthing/Sync";
  };

  systemd.tmpfiles.rules = [
    "d /data/syncthing 0700 syncthing syncthing - - --no-override"
    "d /data/syncthing-conf 0700 syncthing syncthing - - --no-override"
  ];
}
