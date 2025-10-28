{
  self,
  config,
  pkgs,
  ...
}: {
  age.secrets.grafana-env = {
    file = "${self}/secrets/grafana-env.age";
    owner = "grafana";
  };

  age.secrets.searx-prometheus = {
  	file = "${self}/secrets/searx-prometheus.age";
	owner = "prometheus";
  };

  systemd.services.grafana.serviceConfig.EnvironmentFile = config.age.secrets.grafana-env.path;

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
      admin_password = "$__env{GRAFANA_PASSWORD}";
    };

    settings.smtp = {
    	enabled = true;
    	user = "$__env{SMTP_USER}";
    	password = "$__env{SMTP_PASSWORD}";
    	host = "$__env{SMTP_HOST}";
    	from_address = "$__env{SMTP_FROM}";
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

  services.prometheus.exporters.smartctl = {
    enable = true;
    port = 9998;
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
        job_name = "smartctl";
        static_configs = [
          {
            targets = [
              "localhost:${toString config.services.prometheus.exporters.smartctl.port}"
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
