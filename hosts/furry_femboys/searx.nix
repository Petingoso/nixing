{
  self,
  config,
  ...
}: {
  age.secrets.searx.file = "${self}/secrets/searx.age";
  services.searx = {
    enable = true;
    settings = {
      server = {
        base_url = "https://search.pi.undertale.uk";
        bind_address = "::1";
        port = "8100";
        public_instance = false;
        secret_key = config.age.secrets.searx.path;
      };

      general = {
        debug = false;
        instance_name = "Searx @ Furry_Femboys";
        donation_url = false;
        contact_url = false;
        privacypolicy_url = false;
        enable_metrics = false;
      };
      ui = {
        default_locale = "en";
        query_in_title = true;
        infinite_scroll = true;
        center_alignment = true;
        default_theme = "simple";
        theme_args.simple_style = "auto";
        search_on_category_select = false;
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
        "Unit converter plugin"
        "Tracker URL remover"
      ];
    };
  };
}
