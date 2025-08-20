{
  self,
  config,
  pkgs,
  inputs,
  ...
}: {
  age.secrets.searx.file = "${self}/secrets/searx.age";
  services.searx = {
  package = inputs.nixpkgs-unstable-latest.legacyPackages.${pkgs.system}.searxng;
    enable = true;
    redisCreateLocally = true;
    limiterSettings = {
    	botdetection.ip_limit.link_token = true;
        botdetection.ip_lists.pass_searxng_org = true;
    };

    settings = {
      server = {
        base_url = "https://search.undertale.uk";
        bind_address = "::1";
        port = "8100";
        public_instance = true;
        secret_key = config.age.secrets.searx.path;
	limiter = true;
      };

      general = {
        debug = false;
        instance_name = "SearXNG by pet :3";
        donation_url = false;
        contact_url = false;
        privacypolicy_url = false;
        enable_metrics = true;
      };
      ui = {
        default_locale = "en";
        query_in_title = true;
        infinite_scroll = true;
        center_alignment = true;
        default_theme = "simple";
        theme_args.simple_style = "auto";
        hotkeys = "vim";
      };
      search = {
        safe_search = 2;
        autocomplete_min = 2;
        autocomplete = "duckduckgo";
        ban_time_on_fail = 5;
        max_ban_time_on_fail = 120;
      };
      enabled_plugins = [
        "Basic Calculator"
        "Tor check plugin"
	"Self Information"
        "Unit converter plugin"
        "Tracker URL remover"
      ];
    };
  };
}
