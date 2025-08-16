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
  lanraragiDomain = "lrr.${base}";

  vaultServer = "http://localhost:8000";
  searchServer = "http://localhost:8100";
  zncServer = "https://localhost:8200";
  grampsServer = "http://localhost:8300";
  immichServer = "http://localhost:8400";
  lanraragiServer = "http://localhost:8500";

  customCaddy =
    (pkgs.caddy.withPlugins {
      plugins = ["github.com/caddy-dns/cloudflare@v0.2.1" "github.com/corazawaf/coraza-caddy@v2.0.0"];
      # plugins = ["github.com/caddy-dns/cloudflare@v0.2.1"];
      hash = "sha256-tLbQnICquzR7g1sxOzr6+6GyNEwIBfdYVDqcxexyfEI=";
    }).overrideAttrs (finalAttr: prevAttrs: {
      doInstallCheck = false; # until https://github.com/nixos/nixpkgs/issues/430090 gets merged
    });

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


    #    coraza_waf {
    #    		load_owasp_crs
    #    		directives `
    #     			Include @coraza.conf-recommended
    #     			Include @crs-setup.conf.example
    #     			Include @owasp_crs/*.conf
    #     			SecRuleEngine On
    #      `
    # }
        handle_errors 403 {
    	header X-Blocked "true"
    	respond "Your request was blocked. Request ID: {http.request.header.x-request-id}"
    }
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

    virtualHosts."${base}" = {
      extraConfig = ''
          ${commonCaddy}

          header Content-Type text/html

          respond <<HTML
        <html>
          <head><title>Services Dashboard</title></head>
          <body>
            <ul>
              <li><a href="https://${vaultDomain}">Vault</a></li>
              <li><a href="https://${searchDomain}">SearXNG</a></li>
              <li><a href="https://${zncDomain}">ZNC Web</a></li>
              <li><a href="https://${grampsDomain}">Gramps</a></li>
              <li><a href="https://${immichDomain}">Immich</a></li>
              <li><a href="https://${lanraragiDomain}">LANraragi</a></li>
            </ul>
          </body>
        </html>
        HTML 200
      '';
    };

    virtualHosts."${searchDomain}" = {
      extraConfig = ''
        ${commonCaddy}
              	route {
              		basic_auth {
              			pet {env.HTTP_PASS}
        		}

                     		reverse_proxy ${searchServer} {
                      		header_up X-Real-IP {remote_host}
               		# header_up X-Forwarded-For {http.request.header.Cf-Connecting-Ip}
               		#      	header_up X-Real-IP {http.request.header.Cf-Connecting-Ip}
                     		}
              	}
      '';
    };

    virtualHosts."${grampsDomain}" = {
      extraConfig = ''
              ${commonCaddy}

              reverse_proxy ${grampsServer} {
        header_up X-Real-IP {remote_host}
               	# header_up X-Forwarded-For {http.request.header.Cf-Connecting-Ip}
               	#       header_up X-Real-IP {http.request.header.Cf-Connecting-Ip}
              }

      '';
    };

    virtualHosts."${immichDomain}" = {
      extraConfig = ''
        ${commonCaddy}

        reverse_proxy ${immichServer} {
                header_up X-Real-IP {remote_host}
        	# header_up X-Forwarded-For {http.request.header.Cf-Connecting-Ip}
                # header_up X-Real-IP {http.request.header.Cf-Connecting-Ip}
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
               	# header_up X-Forwarded-For {http.request.header.Cf-Connecting-Ip}
               	# header_up X-Real-IP {http.request.header.Cf-Connecting-Ip}
                     }
      '';
    };

    virtualHosts."${vaultDomain}" = {
      extraConfig = ''
        ${commonCaddy}
        reverse_proxy ${vaultServer} {
                header_up X-Real-IP {remote_host}
        	# header_up X-Forwarded-For {http.request.header.Cf-Connecting-Ip}
        	#        header_up X-Real-IP {http.request.header.Cf-Connecting-Ip}
                }
      '';
    };

    virtualHosts."${lanraragiDomain}" = {
      extraConfig = ''
               ${commonCaddy}
        request_body {
        	max_size 200MB
        }

               reverse_proxy ${lanraragiServer} {
                       header_up X-Real-IP {remote_host}
               	# header_up X-Forwarded-For {http.request.header.Cf-Connecting-Ip}
               	#        header_up X-Real-IP {http.request.header.Cf-Connecting-Ip}
                       }
      '';
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/log/caddy 0755 caddy caddy - -"
  ];
}
