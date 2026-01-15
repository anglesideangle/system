{
  # use systemd-resolved for dns
  services.resolved.enable = true;

  networking = {
    hostName = "asa-fw";

    # use systemd-networkd backend instead of scripted networking
    useNetworkd = true;
    # disable deprecated builtin dhcp (manually implemented below)
    useDHCP = false;

    networkmanager = {
      enable = true;
      # wifi.powersave = true;
      dns = "systemd-resolved";
      dhcp = "internal"; # would be better as systemd-networkd, I believe nm vendors in the networkd dhcp server regardless
    };

    firewall.enable = true;
  };

  systemd.network = {
    wait-online.enable = false;

    networks = {
      "20-wireless" = {
        matchConfig.Type = "wlan";
        networkConfig.DHCP = "yes";
      };

      "30-ethernet" = {
        matchConfig.Type = "ether";
        networkConfig.DHCP = "yes";
      };
    };
  };

  # systemd-networkd's dhcp client wants af_packet, but we enable protect
  # lockKernelModules
  # boot.kernelModules = [ "af_packet" ];

  services.avahi.enable = false;
  services.printing.enable = false;
}
