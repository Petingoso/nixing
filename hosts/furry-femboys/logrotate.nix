{...}:{
  fileSystems."/var/log" =
    { device = "none";
      fsType = "tmpfs";
      options = [ "size=50M" "mode=777" ];
      neededForBoot = false;
    };
  	systemd.tmpfiles.rules = [
    	"d /data/logs 0755 root root - -"
    	"d /data/logs/caddy 0755 caddy caddy - -"
  	];

    services.logrotate = {
    	enable = true;
	settings = {
		"/var/log/caddy/*.log" = {
				frequency = "daily";
				compress = true;
				rotate = 3;
				missingok = true;
				create = true;
				postrotate = "find /var/log/caddy/ -name '*.log.*' -exec mv -t /data/logs/caddy {} +";
			};
		};
    };
}
