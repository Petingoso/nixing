{
  self,
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  pkgs' = inputs.nixpkgs-unstable-latest.legacyPackages.${pkgs.system};
in {
  age.secrets.searx.file = "${self}/secrets/searx.age";
  age.secrets.searx-prometheus = {
  	file = "${self}/secrets/searx-prometheus.age";
	mode = "444";
  };
  systemd.tmpfiles.rules = [
    "L+ /run/searx/limiter.toml - - - - /etc/searxng/limiter.toml"
  ];

  services.searx = {
    environmentFile = config.age.secrets.searx.path;
    package = pkgs'.callPackage "${self}/pkgs/searx.nix" {};
    enable = true;
    redisCreateLocally = true;
    limiterSettings = {
      botdetection.ip_limit.filter_link_local = false;
      botdetection.ip_limit.link_token = true;
      botdetection.ip_lists.pass_searxng_org = true;
      botdetection.ip_lists.pass_ip = ["127.0.0.1/32"];
    };

    settings = {
      server = {
        base_url = "https://search.undertale.uk";
        bind_address = "localhost";
        port = "8100";
        public_instance = true;
        image_proxy = true;
        # secret_key = ""; in SEARXNG_SECRET
        limiter = true;
      };

      general = {
        debug = false;
        instance_name = "SearXNG by pet :3";
        donation_url = false;
        contact_url = false;
        privacypolicy_url = false;
        enable_metrics = true;

        #FIXME: use environmentFile and "@SEARX_SECRET_KEY@";
	open_metrics = lib.removeSuffix "\n" (builtins.readFile config.age.secrets.searx-prometheus.path);
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
	#      engines = lib.singleton { 
	#       	name = "brave";
	#        engine = "brave";
	# using_tor_proxy = "true";
	#    };

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
