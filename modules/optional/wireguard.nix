{
  config,
  pkgs,
  self,
  ...
}: {
 age.secrets.wireguard = {
    file = "${self}/secrets/wireguard.age";
    owner = config.users.users.systemd-network.name;
    mode = "400";
  };

  networking.firewall = let
    port = "34266";
  in {
    logReversePathDrops = true;
    extraCommands = ''
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport ${port} -j RETURN
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport ${port} -j RETURN
    '';
    extraStopCommands = ''
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport ${port} -j RETURN || true
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport ${port} -j RETURN || true
    '';
  };

  networking.wg-quick.interfaces.wgrnl = let
    wgrnlFwmark = "765";
  in {
    address = ["192.168.20.81/24" "fd92:3315:9e43:c490::81/64"];
    privateKeyFile = config.age.secrets.wireguard.path;
    table = wgrnlFwmark;
    postUp = ''
      # Setup routing entre routing tables (aka maravilha do Breda)
      ${pkgs.wireguard-tools}/bin/wg set wgrnl fwmark ${wgrnlFwmark}
      ${pkgs.iproute2}/bin/ip rule add not fwmark ${wgrnlFwmark} table ${wgrnlFwmark}
      ${pkgs.iproute2}/bin/ip -6 rule add not fwmark ${wgrnlFwmark} table ${wgrnlFwmark}

      # multicast
      ${pkgs.iproute2}/bin/ip link set wgrnl multicast on
    '';
    postDown = ''
      ${pkgs.iproute2}/bin/ip rule del not fwmark ${wgrnlFwmark} table ${wgrnlFwmark}
      ${pkgs.iproute2}/bin/ip -6 rule del not fwmark ${wgrnlFwmark} table ${wgrnlFwmark}
    '';

    peers = [
      {
        publicKey = "g08PXxMmzC6HA+Jxd+hJU0zJdI6BaQJZMgUrv2FdLBY=";
        endpoint = "193.136.164.216:34266";
        allowedIPs = [
          # gamas públicas da RNL
          "193.136.164.0/24"
          "193.136.154.0/24"
          "2001:690:2100:80::/58"

          # gamas privadas da RNL
          "10.16.64.0/18" # routed dentro do IST

          "192.168.154.0/24"
        ];
        persistentKeepalive = 25;
      }
    ];
  };
}
