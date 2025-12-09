{
  config,
  self,
  lib,
  pkgs,
  ...
}:{
  services.anubis.instances.default = {
    enable = true;
    settings = {
      SERVE_ROBOTS_TXT = true;
      BIND_NETWORK = "tcp";
      BIND = "0.0.0.0:9090";
      TARGET = "http://localhost:${config.services.searx.settings.server.port}";
      POLICY_FNAME = "${./policy.yaml}";
      METRICS_BIND_NETWORK = "tcp";
      METRICS_BIND = "localhost:9091";
    };
  };
}
