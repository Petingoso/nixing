{
  self,
  config,
  ...
}: {
  age.secrets.grafana-password = {
    file = "${self}/secrets/grafana-password.age";
    owner = "grafana";
  };

  age.secrets.searx-prometheus = {
  	file = "${self}/secrets/searx-prometheus.age";
	owner = "prometheus";
  };

  services.grafana = {
    enable = true;
    dataDir = "/data/grafana";
    settings.server = {
      domain = "grafana.undertale.uk";
      http_port = 8600;
      http_addr = "127.0.0.1";
      enable_gzip = true;
    };

    settings.security = {
      admin_password = "$__file{${config.age.secrets.grafana-password.path}}";
    };

    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://localhost:${toString config.services.prometheus.port}";
          isDefault = true;
          editable = false;
        }
      ];
    };
  };

  services.prometheus.exporters.node = {
    enable = true;
    port = 9999;
    enabledCollectors = ["systemd"];
  };

  services.prometheus = {
    enable = true;
    port = 9001;
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          {
            targets = [
              "localhost:${toString config.services.prometheus.exporters.node.port}"
            ];
          }
        ];
      }
      {
        job_name = "caddy";
        static_configs = [
          {
            targets = ["localhost:2019"];
          }
        ];
      }
      {
        job_name = "searxng";
        static_configs = [
          {
            targets = ["localhost:8100"];
          }
        ];
        basic_auth = {
          username = "anything";
          password_file = config.age.secrets.searx-prometheus.path;
        };
      }
    ];
  };
}
