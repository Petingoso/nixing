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
  webdavDomain = "dav.${base}";
  grafanaDomain = "grafana.${base}";

  vaultServer = "http://localhost:${config.services.vaultwarden.config.ROCKET_PORT}";
  searchServer = "http://localhost:${config.services.searx.settings.server.port}";
  zncServer = "https://localhost:${toString config.services.znc.config.Listener.web.Port}";
  grampsServer = "http://localhost:8300";
  immichServer = "http://localhost:${toString config.services.immich.port}";
  lanraragiServer = "http://localhost:${toString config.services.lanraragi.port}";
  grafanaServer = "http://localhost:${toString config.services.grafana.settings.server.http_port}";

  customCaddy =
    (pkgs.caddy.withPlugins {
      # plugins = ["github.com/caddy-dns/cloudflare@v0.2.1" "github.com/corazawaf/coraza-caddy@v2.0.0"];
      # plugins = ["github.com/caddy-dns/cloudflare@v0.2.1" "github.com/mholt/caddy-webdav@v0.0.0-20250805175825-7a5c90d8bf90"];
      plugins = ["github.com/caddy-dns/cloudflare@v0.2.1" 
      		 "github.com/mholt/caddy-webdav@v0.0.0-20250805175825-7a5c90d8bf90" 
		 "github.com/mholt/caddy-ratelimit@v0.0.0-20250915152450-04ea34edc0c4"];
      hash = "sha256-TEnFZhxVlFOxo5VlgGzehCN5EKvkwZ3JTaBUSLy3h1A=";
      # hash = lib.fakeHash;
      });
    # }).overrideAttrs (finalAttr: prevAttrs: {
    #   doInstallCheck = false; # until https://github.com/nixos/nixpkgs/issues/430090 gets merged
    # });

  commonCaddy = ''
           encode zstd gzip

            header {

	    	Strict-Transport-Security max-age=15768000;
               	X-Content-Type-Options nosniff
               	X-Frame-Options SAMEORIGIN

    		Referrer-Policy "same-origin"
    		Permissions-Policy "accelerometer=(),camera=(),geolocation=(),gyroscope=(),magnetometer=(),microphone=(),payment=(),usb=()"
            	-Server


            }

            tls {
     ciphers TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256 TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
      	  curves x25519 secp256r1 secp384r1

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

  caddyCSP = ''
     	header {
      	Content-Security-Policy "upgrade-insecure-requests; default-src 'none'; script-src 'self'; style-src 'self' 'unsafe-inline'; form-action 'self' https:; font-src 'self'; frame-ancestors 'self'; base-uri 'self'; connect-src 'self'; img-src * data:; frame-src https:; media-src 'self' data:;"
    }
  '';

  blockEngines = ''header X-Robots-Tag "noindex, nofollow, noarchive, nositelinkssearchbox, nosnippet, notranslate, noimageindex" '';
in {
  age.secrets.caddy-env.file = "${self}/secrets/caddy-env.age";

  networking.firewall.allowedTCPPorts = [80 443];
  networking.firewall.allowedUDPPorts = [443];
  services.caddy = {
    enable = true;
    package = customCaddy;
    environmentFile = config.age.secrets.caddy-env.path;
    globalConfig = ''
    	# experimental_http3

        metrics {
      		per_host
      }
      # order coraza_waf first
    '';

    virtualHosts."${base}" = {
      extraConfig = ''
               ${commonCaddy}
        ${caddyCSP}

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
                   <li><a href="https://${grafanaDomain}">Grafana</a></li>
                 </ul>
               </body>
             </html>
             HTML 200
      '';
    };

    virtualHosts."${searchDomain}" = {
      extraConfig = ''
               ${commonCaddy}
               ${caddyCSP}
                     	route {
                   		basic_auth {
                   			pet {env.HTTP_PASS}
             		}

				rate_limit {
					zone searx {
						match {
							path /
						}
						key    "{http.request.remote.host}"
						window 1m
						events 50
					}

					log_key
					sweep_interval 5m
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
        ${blockEngines}
        ${caddyCSP}

               reverse_proxy ${grampsServer} {
                	header_up X-Forwarded-For {http.request.header.Cf-Connecting-Ip}
                	header_up X-Real-IP {http.request.header.Cf-Connecting-Ip}
               }

      '';
    };

    virtualHosts."${immichDomain}" = {
      extraConfig = ''
               ${commonCaddy}
        ${blockEngines}

        #          header / {
        # 	Content-Security-Policy "script-src 'self' 'sha256-wLJx7Ib2MaFxhBI5LpH40lcj0iaiViv8uXI1T1qeKBw=' 'sha256-MtXRGQMzwmzbE87XBKi1xn/0fTPqdszSyfdSGmfvH7c='; upgrade-insecure-requests; default-src 'none';  style-src 'self' 'unsafe-inline'; form-action 'self' https:; font-src 'self'; frame-ancestors 'self'; base-uri 'self'; connect-src 'self'; img-src * data:; frame-src https:;"
        # }
               reverse_proxy ${immichServer} {
                       header_up X-Real-IP {remote_host}
                     }

      '';
    };
    virtualHosts."${zncDomain}" = {
      extraConfig = ''
               ${commonCaddy}
        ${blockEngines}
        ${caddyCSP}

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
        ${blockEngines}
        ${caddyCSP}

               reverse_proxy ${vaultServer} {
               	header_up X-Forwarded-For {http.request.header.Cf-Connecting-Ip}
               	header_up X-Real-IP {http.request.header.Cf-Connecting-Ip}
                       }
      '';
    };

    virtualHosts."${grafanaDomain}" = {
      extraConfig = ''
               ${commonCaddy}
        ${blockEngines}

               reverse_proxy ${grafanaServer} {
               	header_up X-Forwarded-For {http.request.header.Cf-Connecting-Ip}
               	header_up X-Real-IP {http.request.header.Cf-Connecting-Ip}
                       }
      '';
    };

    virtualHosts."${lanraragiDomain}" = {
      extraConfig = ''
        ${commonCaddy}
        ${blockEngines}

               request_body {
               	max_size 200MB
               }

                      reverse_proxy ${lanraragiServer} {
                              header_up X-Real-IP {remote_host}
                              }
      '';
    };

    virtualHosts."${webdavDomain}" = {
      extraConfig = ''
                    ${commonCaddy}
             ${blockEngines}
             ${caddyCSP}

             root * /data/webDAV
                   	route {
        request_body {
        	max_size 10GB
        }

                   		basic_auth {
                   			pet {env.HTTP_PASS}
             		}

        webdav

                   	}
      '';
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/log/caddy 0755 caddy caddy - -"
    "d /data/webDAV 0750 caddy caddy - -"
  ];
}
