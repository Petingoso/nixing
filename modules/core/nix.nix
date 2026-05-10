{config, ...}: {
  nix = {
    settings = {
      experimental-features = [
        "flakes"
        "nix-command"
      ];
      lint-url-literals = "fatal";
      trusted-users = [
        "root"
        config.custom.username
      ];
      auto-optimise-store = true;
      keep-outputs = true;
      # keep-derivations = true;
      use-xdg-base-directories = true;
      fallback = true;
      warn-dirty = false;
    };
  };
}
