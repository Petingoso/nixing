{config,self,lib,...}:{
	age.secrets.lanraragi.file = "${self}/secrets/lanraragi.age";

	services.lanraragi = {
		enable = true;
		port = 8500;
		passwordFile = config.age.secrets.lanraragi.path;
	};

  	fileSystems."/var/lib/private/lanraragi" = {
	  	device = "/data/lanraragi";
		options = [ "bind" ];
  	};

	systemd.tmpfiles.rules = [
  		"d /data/lanraragi 0700 root root - - --no-override"
	];
}
