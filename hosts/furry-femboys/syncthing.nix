{...}:{
services.syncthing = {
  enable = true;
  openDefaultPorts = true;
  guiAddress = "0.0.0.0:8384"; 
  dataDir = "/data/syncthing";
};

networking.firewall.allowedTCPPorts = [ 8384 ];

systemd.tmpfiles.rules = [
    "d /data/syncthing 0700 syncthing syncthing - - --no-override"
];

}
