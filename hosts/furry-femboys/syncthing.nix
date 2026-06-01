{...}:{
services.syncthing = {
  enable = true;
  openDefaultPorts = true;
  guiAddress = "0.0.0.0:8384"; 
};

networking.firewall.allowedTCPPorts = [ 8384 ];
}
