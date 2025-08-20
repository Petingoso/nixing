{self,config,...}:{
  age.secrets.grafana-password = {
  	file = "${self}/secrets/grafana-password.age";
  	owner = "grafana";
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
  };
}


