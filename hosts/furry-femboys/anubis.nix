{
  config,
  self,
  lib,
  pkgs,
  ...
}: {
  services.anubis.instances.default = {
    enable = true;
    botPolicy = {
      bots = [
        {
          name = "searx-checker";
          action = "ALLOW";
          expression = {
            remote_addresses = [
              "167.235.158.251/32"
              "2a01:4f8:1c1c:8fc2::1/128"
            ];
          };
        }
      ];
      import = "(data)/meta/default-config.yaml";
      dnsbl = true;
    };

    settings = {
      SERVE_ROBOTS_TXT = true;
      BIND_NETWORK = "tcp";
      BIND = "localhost:9090";
      TARGET = "http://localhost:${config.services.searx.settings.server.port}";
      # POLICY_FNAME = builtins.toFile "policy.yaml" (builtins.toJSON bots);
      # POLICY_FNAME = builtins.toFile "./policy";
    };
  };
}
