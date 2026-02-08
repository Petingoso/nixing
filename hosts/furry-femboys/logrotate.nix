{...}:{
  fileSystems."/var/log/caddy" =
    { device = "none";
      fsType = "tmpfs";
      options = [ "size=100M" "mode=777" ];
      neededForBoot = false;
    };
  	systemd.tmpfiles.rules = [
    	"d /data/logs 0755 root root - -"
    	"d /data/logs/caddy 0755 caddy caddy - -"
  	];

  systemd.services.logrotate.serviceConfig.ExecStopPost = "/usr/bin/env systemctl restart caddy";
    services.logrotate = {
    	enable = true;
	settings = {
		"/var/log/caddy/*.log" = {
				frequency = "daily";
				compress = true;
				rotate = 3;
				missingok = true;
				create = true;
				postrotate = "find /var/log/caddy/ -name '*.log*' -exec mv -t /data/logs/caddy {} +";
			};
		};
    };
}
