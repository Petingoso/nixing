{pkgs, ...}: {
  environment.systemPackages = [pkgs.dualsensectl pkgs.trigger-control];

  services = {
    udev = {
      packages = with pkgs; [
        game-devices-udev-rules
      ];
    };
  };

  hardware.uinput.enable = true;

    services.udev.extraRules = ''
    SUBSYSTEM=="sound", ACTION=="change", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", ENV{SOUND_DESCRIPTION}="Wireless Controller"
  '';

}
