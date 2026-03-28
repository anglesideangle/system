{
  pkgs,
  ...
}:
{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.gnome.core-apps.enable = true;
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = false;
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];

  programs.dconf.profiles.user.databases = [
    {
      lockAll = true;
      settings = {
        "org/gnome/desktop/input-sources" = {
          xkb-options = [ "caps:escape" ];
        };
        # "org/gnome/mutter" = {
        #   experimental-features = [
        #     "scale-monitor-framebuffer"
        #     "variable-refresh-rate"
        #     "xwayland-native-scaling"
        #     "autoclose-xwayland"
        #   ];
        # };
      };
    }
  ];

  environment.variables = {
    EDITOR = "hx";
  };
}
