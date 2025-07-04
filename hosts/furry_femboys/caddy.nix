{
  self,
  pkgs,
  config,
  lib,
  ...
}: let
  base = "undertale.uk";
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
    # plugins = ["github.com/caddy-dns/cloudflare@v0.2.1" "github.com/corazawaf/coraza-caddy@v2.0.0"];
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


    # coraza_waf {
    # 		load_owasp_crs
    # 		directives `
    #  			Include @coraza.conf-recommended
    #  			Include @crs-setup.conf.example
    #  			Include @owasp_crs/*.conf
    #  			SecRuleEngine On
    #   `
    # }
  '';
in {
  age.secrets.caddy-env.file = "${self}/secrets/caddy-env.age";

  networking.firewall.allowedTCPPorts = [80 443];
  services.caddy = {
    enable = true;
    package = customCaddy;
    environmentFile = config.age.secrets.caddy-env.path;
    globalConfig = ''
      # order coraza_waf first
    '';
    virtualHosts."${searchDomain}" = {
      extraConfig = ''
             	${commonCaddy}
        route{
        basic_auth {
        	pet {env.HTTP_PASS}

        }
               reverse_proxy ${searchServer} {
         header_up X-Forwarded-For {http.request.header.Cf-Connecting-Ip}
                header_up X-Real-IP {http.request.header.Cf-Connecting-Ip}
               }
        }
      '';
    };

    virtualHosts."${grampsDomain}" = {
      extraConfig = ''
        ${commonCaddy}

        reverse_proxy ${grampsServer} {
         header_up X-Forwarded-For {http.request.header.Cf-Connecting-Ip}
                header_up X-Real-IP {http.request.header.Cf-Connecting-Ip}
        }

      '';
    };

    virtualHosts."${immichDomain}" = {
      extraConfig = ''
              ${commonCaddy}

        reverse_proxy ${immichServer} {
		header_up X-Forwarded-For {http.request.header.Cf-Connecting-Ip}
                header_up X-Real-IP {http.request.header.Cf-Connecting-Ip}
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
               # header_up X-Real-IP {remote_host}
         header_up X-Forwarded-For {http.request.header.Cf-Connecting-Ip}
                header_up X-Real-IP {http.request.header.Cf-Connecting-Ip}
              }
      '';
    };

    virtualHosts."${vaultDomain}" = {
      extraConfig = ''
              ${commonCaddy}
                     reverse_proxy ${vaultServer} {
                       # header_up X-Real-IP {remote_host}
        header_up X-Forwarded-For {http.request.header.Cf-Connecting-Ip}
                      header_up X-Real-IP {http.request.header.Cf-Connecting-Ip}
                     }
      '';
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/log/caddy 0755 caddy caddy - -"
  ];
}
