{config, ...}: {
  nix = {
    settings = {
      experimental-features = [
        "flakes"
        "nix-command"
      ];
      trusted-users = [
        "root"
        config.mystuff.other.system.username
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
