_: {
  boot.loader = {
    systemd-boot = {
      enable = true;
      memtest86.enable = true;
      editor = false;
    };
    efi.canTouchEfiVariables = true;
  };
}
