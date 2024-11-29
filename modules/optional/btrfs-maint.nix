_: {
  services = {
    btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
    };
    fstrim = {
      enable = true;
      interval = "weekly";
    };
  };
}
