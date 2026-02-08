_: {
  services.dbus = {
    enable = true;
    implementation = "broker";
  };
  services.upower.enable = true;
}
