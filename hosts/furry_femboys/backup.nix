{config,...}:{
  services.borgbackup.jobs.gramps = {
    paths = "/data/docker/volumes/gramps_gramps_db";
    repo = "/data/backup/gramps";
    encryption.mode = "none";
    compression = "auto,zstd";
    startAt = "daily";
    prune.keep = {
  	daily = 4;
  	weekly = 2;
  	monthly = -1;  # Keep at least one archive for each month
    };
  };
}

