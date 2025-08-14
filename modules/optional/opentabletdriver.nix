_: {
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };
  # might be needed for open tablet driver to work?
  services.udev.extraRules = ''
    #   KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    # '';
}
