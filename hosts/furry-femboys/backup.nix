{ config, ... }: {
  services.borgbackup.jobs.gramps = {
    paths = "/data/docker/volumes/gramps_gramps_db";
    repo = "/data/backup/gramps";
    doInit = true;
    encryption.mode = "none";
    compression = "auto,zstd";
    startAt = "daily";
    prune.keep = {
      daily = 4;
      weekly = 2;
      monthly = -1; # Keep at least one archive for each month
    };
    exclude = [ "/data/backup/gramps" ]; # Prevent self-backing

  };

  services.borgbackup.jobs.archive = {
    paths = [
      "/data/backup/gramps"
      "/data/backup/vaultwarden"
      "/data/immich/"
      "/data/lanraragi/content"
      "/data/webDAV"
      "/var/lib/redis-lanraragi"
    ];
    preHook = ''
      set -euo pipefail
      ${config.services.redis.package}/bin/redis-cli \
        -p ${toString config.services.redis.servers.lanraragi.port} \
        -a "$(cat ${config.age.secrets.lanraragi.path})" \
        --no-auth-warning \
        SAVE
    '';

    doInit = true;
    repo = "/backups/repo";
    encryption.mode = "none";
    compression = "auto,zstd";
    startAt = "weekly";
    prune.keep = {
      weekly = 2;
      monthly = -1; # Keep at least one archive for each month
    };
  };
}
