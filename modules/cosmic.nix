{ pkgs, ... }: {
  services.displayManager.cosmic-greeter.enable = true;

  services.desktopManager.cosmic.enable = true;
  services.desktopManager.cosmic.xwayland.enable = false;

  services.system76-scheduler.enable = true;

  environment.systemPackages = [ pkgs.wl-clipboard ];

  systemd.services.NetworkManager-wait-online.enable = false;

  environment.variables = {
    EDITOR = "hx";
  };
}
