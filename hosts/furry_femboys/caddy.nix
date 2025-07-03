{
  self,
  pkgs,
  config,
  lib,
  ...
}: let
  base = "pi.undertale.uk";
  vaultDomain = "vault.${base}";
  searchDomain = "search.${base}";
  zncDomain = "irc.${base}";
  grampsDomain = "gramps.${base}";
  immichDomain = "photos.${base}";

  vaultServer = "http://localhost:8000";
  searchServer = "http://localhost:8100";
  zncServer = "https://localhost:8200";
  grampsServer = "http://localhost:8300";
  immichServer = "http://localhost:8400";

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
  age.secrets.caddy-env.file = "${self}/secrets/caddy-env.age";

  environment.etc = {
    "fail2ban/filter.d/caddy.conf".text = ''
      [Definition]
      failregex = ^.*"remote_ip":"<HOST>",.*?"status":(?:401|403|500),.*$
      ignoreregex =
      datepattern = LongEpoch
    '';
  };

  services.fail2ban.jails = {
    "caddy" = ''
      enabled = true
      filter = caddy
      findtime = 600
      maxretry = 4
      logpath = /var/log/caddy/access*.log
      backend = auto
    '';
  };

  networking.firewall.allowedTCPPorts = [80 443];
  services.caddy = {
    enable = true;
    package = customCaddy;
    environmentFile = config.age.secrets.caddy-env.path;

    virtualHosts."${searchDomain}" = {
      extraConfig = ''
             	${commonCaddy}
        route{
        basic_auth {
        	pet {env.HTTP_PASS}

        }
               reverse_proxy ${searchServer} {
                header_up X-Real-IP {remote_host}
               }
        }
      '';
    };

    virtualHosts."${grampsDomain}" = {
      extraConfig = ''
        ${commonCaddy}

        reverse_proxy ${grampsServer} {
                header_up X-Real-IP {remote_host}
        }

      '';
    };

    virtualHosts."${immichDomain}" = {
      extraConfig = ''
        ${commonCaddy}

        reverse_proxy ${immichServer} {
                header_up X-Real-IP {remote_host}
        }

      '';
    };
    virtualHosts."${zncDomain}" = {
      extraConfig = ''
            	${commonCaddy}
              reverse_proxy ${zncServer} {
        transport http {
               	tls
               	tls_insecure_skip_verify
        }
               header_up X-Real-IP {remote_host}
              }
      '';
    };

    virtualHosts."${vaultDomain}" = {
      extraConfig = ''
        ${commonCaddy}
               reverse_proxy ${vaultServer} {
                 header_up X-Real-IP {remote_host}
               }
      '';
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/log/caddy 0755 caddy caddy - -"
  ];
}
