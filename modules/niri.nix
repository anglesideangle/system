
{
  lib,
  pkgs,
  packages,
  ...
}:
{
  systemd.user.services = {
    swayidle = {
      enable = true;
      unitConfig = {
        PartOf = "graphical-session.target";
        After = "graphical-session.target";
        Requisite = "graphical-session.target";
      };
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.swayidle} -w timeout 300 '${lib.getExe pkgs.niri} msg action power-off-monitors' timeout 300 '${lib.getExe packages.swaylock-wrapped} -f' before-sleep '${lib.getExe packages.swaylock-wrapped} -f'";
        Restart = "on-failure";
      };
    };
  };

  programs.niri = {
    enable = true;
    package = packages.niri-wrapped;
  };

  programs.waybar = {
    enable = true;
    package = packages.waybar-wrapped;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${lib.getExe pkgs.tuigreet} --time --cmd 'bash -l -c ${lib.getExe' packages.niri-wrapped "niri-session"}'";
        user = "greeter";
      };
    };
  };

  # https://github.com/YaLTeR/niri/wiki/Important-Software

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    gnome-themes-extra
    nautilus
    packages.mako-wrapped
    packages.fuzzel-wrapped
    wl-clipboard
    xwayland-satellite
    networkmanagerapplet
  ];

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # some gnome settings (dark mode)
  programs.dconf.profiles.user.databases = [
    {
      lockAll = true;
      settings = {
        "org/gnome/desktop/interface" = {
          accent-color = "teal";
          color-scheme = "prefer-dark";
        };
      };
    }
  ];

  # configure xdg portals and default apps
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };

  # default handlers
  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [ "Alacritty.desktop" ];
    };
  };

  xdg.mime.defaultApplications = {
    "x-scheme-handler/http" = "org.mozilla.firefox.desktop";
    "x-scheme-handler/https" = "org.mozilla.firefox.desktop";
    "x-scheme-handler/ftp" = "org.mozilla.firefox.desktop";
    "x-scheme-handler/mailto" = "org.mozilla.thunderbird.desktop";
    "text/plain" = "Helix.desktop";
    "application/pdf" = "org.mozilla.firefox.desktop";
    # "image/png" = [
    #   "sxiv.desktop"
    #   "gimp.desktop"
    # ];
  };
}
