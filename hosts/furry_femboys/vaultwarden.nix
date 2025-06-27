{self,config,...}: {
  age.secrets.vaultwarden-token.file = "${self}/secrets/vaultwarden-token.age";

    services.vaultwarden = {
    	enable = true;
	backupDir = "/data/backup/vaultwarden";
    	environmentFile = config.age.secrets.vaultwarden-token.path;
	config = {
		WEB_VAULT_ENABLED = true;
		DOMAIN = "https://pi.undertale.uk";
		SIGNUPS_ALLOWED=false;
		INVITATIONS_ALLOWED=false;
	};
    };
}
