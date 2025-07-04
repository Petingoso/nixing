{
  pkgs,
  config,
  self,
  ...
}: {
  age.identityPaths = ["/home/pet/.ssh/id_ed25519"];
  age.secrets.cloudflare.file = "${self}/secrets/cloudflare.age";
  services.ddclient = {
    enable = true;
    domains = ["pi.undertale.uk"];
    protocol = "cloudflare";
    zone = "undertale.uk";
    username = "token";
    usev4 = "webv4, webv4='https://cloudflare.com/cdn-cgi/trace',web-skip='ip='";
    usev6 = "webv6, webv6='https://cloudflare.com/cdn-cgi/trace',webv6-skip='ip='";

    extraConfig = ''
      ttl=1,
      login=token,
    '';
    passwordFile = config.age.secrets.cloudflare.path;
  };
}
