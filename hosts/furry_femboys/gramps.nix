# Auto-generated using compose2nix v0.3.1. + modified manually
{
  config,
  pkgs,
  lib,
  self,
  ...
}: {
  age.secrets.gramps-env.file = "${self}/secrets/gramps-env.age";
  # Runtime
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
    daemon.settings = {
      data-root = "/data/docker";
    };
  };

  virtualisation.oci-containers.backend = "docker";

  virtualisation.oci-containers.containers."gramps-grampsweb" = {
    environmentFiles = [config.age.secrets.gramps-env.path];
    image = "ghcr.io/gramps-project/grampsweb:latest";
    environment = {
      "GRAMPSWEB_CELERY_CONFIG__broker_url" = "redis://grampsweb_redis:6379/0";
      "GRAMPSWEB_CELERY_CONFIG__result_backend" = "redis://grampsweb_redis:6379/0";
      "GRAMPSWEB_GUNICORN_NUM_WORKERS" = "1";
      "GRAMPSWEB_RATELIMIT_STORAGE_URI" = "redis://grampsweb_redis:6379/1";
      "GRAMPSWEB_BASE_URL" = "https://gramps.pi.undertale.uk";
    };
    volumes = [
      "gramps_gramps_cache:/app/cache:rw"
      "gramps_gramps_db:/root/.gramps/grampsdb:rw"
      "gramps_gramps_index:/app/indexdir:rw"
      "gramps_gramps_media:/app/media:rw"
      "gramps_gramps_secret:/app/secret:rw"
      "gramps_gramps_thumb_cache:/app/thumbnail_cache:rw"
      "gramps_gramps_tmp:/tmp:rw"
      "gramps_gramps_users:/app/users:rw"
    ];
    ports = [
      "8300:5000/tcp"
    ];
    dependsOn = [
      "grampsweb_redis"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=grampsweb"
      "--network=gramps_default"
    ];
  };
  systemd.services."docker-gramps-grampsweb" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-gramps_default.service"
      "docker-volume-gramps_gramps_cache.service"
      "docker-volume-gramps_gramps_db.service"
      "docker-volume-gramps_gramps_index.service"
      "docker-volume-gramps_gramps_media.service"
      "docker-volume-gramps_gramps_secret.service"
      "docker-volume-gramps_gramps_thumb_cache.service"
      "docker-volume-gramps_gramps_tmp.service"
      "docker-volume-gramps_gramps_users.service"
    ];
    requires = [
      "docker-network-gramps_default.service"
      "docker-volume-gramps_gramps_cache.service"
      "docker-volume-gramps_gramps_db.service"
      "docker-volume-gramps_gramps_index.service"
      "docker-volume-gramps_gramps_media.service"
      "docker-volume-gramps_gramps_secret.service"
      "docker-volume-gramps_gramps_thumb_cache.service"
      "docker-volume-gramps_gramps_tmp.service"
      "docker-volume-gramps_gramps_users.service"
    ];
    partOf = [
      "docker-compose-gramps-root.target"
    ];
    wantedBy = [
      "docker-compose-gramps-root.target"
    ];
  };
  virtualisation.oci-containers.containers."grampsweb_celery" = {
    image = "ghcr.io/gramps-project/grampsweb:latest";
    environment = {
      "GRAMPSWEB_CELERY_CONFIG__broker_url" = "redis://grampsweb_redis:6379/0";
      "GRAMPSWEB_CELERY_CONFIG__result_backend" = "redis://grampsweb_redis:6379/0";
      "GRAMPSWEB_RATELIMIT_STORAGE_URI" = "redis://grampsweb_redis:6379/1";
      "GRAMPSWEB_TREE" = "Gramps Web";
    };
    volumes = [
      "gramps_gramps_cache:/app/cache:rw"
      "gramps_gramps_db:/root/.gramps/grampsdb:rw"
      "gramps_gramps_index:/app/indexdir:rw"
      "gramps_gramps_media:/app/media:rw"
      "gramps_gramps_secret:/app/secret:rw"
      "gramps_gramps_thumb_cache:/app/thumbnail_cache:rw"
      "gramps_gramps_tmp:/tmp:rw"
      "gramps_gramps_users:/app/users:rw"
    ];
    cmd = ["celery" "-A" "gramps_webapi.celery" "worker" "--loglevel=INFO" "--concurrency=2"];
    dependsOn = [
      "grampsweb_redis"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=grampsweb_celery"
      "--network=gramps_default"
    ];
  };
  systemd.services."docker-grampsweb_celery" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-gramps_default.service"
      "docker-volume-gramps_gramps_cache.service"
      "docker-volume-gramps_gramps_db.service"
      "docker-volume-gramps_gramps_index.service"
      "docker-volume-gramps_gramps_media.service"
      "docker-volume-gramps_gramps_secret.service"
      "docker-volume-gramps_gramps_thumb_cache.service"
      "docker-volume-gramps_gramps_tmp.service"
      "docker-volume-gramps_gramps_users.service"
    ];
    requires = [
      "docker-network-gramps_default.service"
      "docker-volume-gramps_gramps_cache.service"
      "docker-volume-gramps_gramps_db.service"
      "docker-volume-gramps_gramps_index.service"
      "docker-volume-gramps_gramps_media.service"
      "docker-volume-gramps_gramps_secret.service"
      "docker-volume-gramps_gramps_thumb_cache.service"
      "docker-volume-gramps_gramps_tmp.service"
      "docker-volume-gramps_gramps_users.service"
    ];
    partOf = [
      "docker-compose-gramps-root.target"
    ];
    wantedBy = [
      "docker-compose-gramps-root.target"
    ];
  };
  virtualisation.oci-containers.containers."grampsweb_redis" = {
    image = "docker.io/library/redis:7.2.4-alpine";
    log-driver = "journald";
    extraOptions = [
      "--network-alias=grampsweb_redis"
      "--network=gramps_default"
    ];
  };
  systemd.services."docker-grampsweb_redis" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-gramps_default.service"
    ];
    requires = [
      "docker-network-gramps_default.service"
    ];
    partOf = [
      "docker-compose-gramps-root.target"
    ];
    wantedBy = [
      "docker-compose-gramps-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-gramps_default" = {
    path = [pkgs.docker];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f gramps_default";
    };
    script = ''
      docker network inspect gramps_default || docker network create gramps_default
    '';
    partOf = ["docker-compose-gramps-root.target"];
    wantedBy = ["docker-compose-gramps-root.target"];
  };

  # Volumes
  systemd.services."docker-volume-gramps_gramps_cache" = {
    path = [pkgs.docker];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect gramps_gramps_cache || docker volume create gramps_gramps_cache
    '';
    partOf = ["docker-compose-gramps-root.target"];
    wantedBy = ["docker-compose-gramps-root.target"];
  };
  systemd.services."docker-volume-gramps_gramps_db" = {
    path = [pkgs.docker];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect gramps_gramps_db || docker volume create gramps_gramps_db
    '';
    partOf = ["docker-compose-gramps-root.target"];
    wantedBy = ["docker-compose-gramps-root.target"];
  };
  systemd.services."docker-volume-gramps_gramps_index" = {
    path = [pkgs.docker];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect gramps_gramps_index || docker volume create gramps_gramps_index
    '';
    partOf = ["docker-compose-gramps-root.target"];
    wantedBy = ["docker-compose-gramps-root.target"];
  };
  systemd.services."docker-volume-gramps_gramps_media" = {
    path = [pkgs.docker];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect gramps_gramps_media || docker volume create gramps_gramps_media
    '';
    partOf = ["docker-compose-gramps-root.target"];
    wantedBy = ["docker-compose-gramps-root.target"];
  };
  systemd.services."docker-volume-gramps_gramps_secret" = {
    path = [pkgs.docker];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect gramps_gramps_secret || docker volume create gramps_gramps_secret
    '';
    partOf = ["docker-compose-gramps-root.target"];
    wantedBy = ["docker-compose-gramps-root.target"];
  };
  systemd.services."docker-volume-gramps_gramps_thumb_cache" = {
    path = [pkgs.docker];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect gramps_gramps_thumb_cache || docker volume create gramps_gramps_thumb_cache
    '';
    partOf = ["docker-compose-gramps-root.target"];
    wantedBy = ["docker-compose-gramps-root.target"];
  };
  systemd.services."docker-volume-gramps_gramps_tmp" = {
    path = [pkgs.docker];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect gramps_gramps_tmp || docker volume create gramps_gramps_tmp
    '';
    partOf = ["docker-compose-gramps-root.target"];
    wantedBy = ["docker-compose-gramps-root.target"];
  };
  systemd.services."docker-volume-gramps_gramps_users" = {
    path = [pkgs.docker];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect gramps_gramps_users || docker volume create gramps_gramps_users
    '';
    partOf = ["docker-compose-gramps-root.target"];
    wantedBy = ["docker-compose-gramps-root.target"];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-gramps-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = ["multi-user.target"];
  };
}
