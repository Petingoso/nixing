{
  self,
  pkgs,
  config,
  lib,
  ...
}: let
  vaultDomain = "vault.pi.undertale.uk";
  searchDomain = "search.pi.undertale.uk";
  vaulServer = "http://localhost:8000";
  searchServer = "http://localhost:8100";
  logFile = "/var/log/caddy/vaultwarden.log"; # Replace with your desired log path
  customCaddy = pkgs.caddy.withPlugins {
    plugins = ["github.com/caddy-dns/cloudflare@v0.2.1"];
    hash = "sha256-Gsuo+ripJSgKSYOM9/yl6Kt/6BFCA6BuTDvPdteinAI=";
  };
  commonCaddy = ''
    encode zstd gzip

     header / {
        	X-Content-Type-Options nosniff
        	X-Frame-Options SAMEORIGIN
     -Server
     }

     tls {
     protocols tls1.2 tls1.3
     dns cloudflare {env.CF_API_TOKEN}
     }

  '';
in {
  age.secrets.cloudflare-env.file = "${self}/secrets/cloudflare-env.age";
  networking.firewall.allowedTCPPorts = [80 443];
  services.caddy = {
    enable = true;
    package = customCaddy;
    environmentFile = config.age.secrets.cloudflare-env.path;

    virtualHosts."${searchDomain}" = {
      extraConfig = ''
             	${commonCaddy}
        route{
        basic_auth {
        	pet $2a$14$0R0sdYlbzYayE90W9/UQu.LJRLlqHNT6plbZj6MX6v7C8Z3Gpl3H6

        }
               reverse_proxy ${searchServer} {
                header_up X-Real-IP {remote_host}
               }
        }
      '';
    };

    virtualHosts."${vaultDomain}" = {
      extraConfig = ''
        ${commonCaddy}
               log {
                 level INFO
                 output file ${logFile} {
                   roll_size 10MB
                   roll_keep 10
                }
               }


        @ip_request {
           		not host ${vaultDomain}
         	}


        	redir @ip_request https://${vaultDomain}{uri}

               reverse_proxy ${vaulServer} {
                 header_up X-Real-IP {remote_host}
               }
      '';
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/log/caddy 0755 caddy caddy - -"
  ];
}
