{
  lib,
  self,
  config,
  pkgs,
  ...
}: {
  environment.etc = {
    "fail2ban/filter.d/caddy.conf".text = ''
      [Definition]
      failregex = ^.*"Cf-Connecting-Ip":\["<HOST>"\].*?"status":(?:401|403|500),.*$
      ignoreregex =
      datepattern = LongEpoch
    '';

    "fail2ban/filter.d/immich.conf".text = ''
      [Definition]
      failregex = Failed login attempt for user .* from ip address <HOST>
    '';

    "fail2ban/action.d/cloudflare_custom.conf".text = lib.readFile ./cloudflare.conf;
  };

  age.secrets.fail2ban-env.file = "${self}/secrets/fail2ban-env.age";

  services.fail2ban.enable = true;

  systemd.services.fail2ban = {
    path = [
      pkgs.curl
    ];
    serviceConfig.EnvironmentFile = "${config.age.secrets.fail2ban-env.path}";
  };

  services.fail2ban.jails = {
    "caddy" = ''
      enabled = true
      filter = caddy
      findtime = 600
      maxretry = 3
      logpath = /var/log/caddy/access*.log
      backend = auto
      action = iptables[type=allports, protocol=all] cloudflare_custom
    '';

    "immich" = ''
      enabled = true
      filter = immich
      findtime = 600
      maxretry = 3
      backend = systemd
      journalmatch = _SYSTEMD_UNIT=immich-server.service
      action = iptables[type=allports, protocol=all] cloudflare_custom
    '';
  };
}
