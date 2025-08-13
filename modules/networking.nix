{
  ...
}:
{
  networking.hostName = "asa-fw"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager = {
    enable = true;
    wifi.backend = "wpa_supplicant";
  };
  programs.nm-applet.enable = true; # cursed wifi widget

  # networking.firewall = {
  #   enable = true;
  #   allowedUDPPorts = [11311];
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # services.avahi = {
  #   enable = true;
  #   nssmdns4 = true;
  #   openFirewall = true;
  # };
}
