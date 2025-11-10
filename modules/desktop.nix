{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.noctalia.nixosModules.default
  ];

  services.noctalia-shell = {
    # package = pkgs.noctalia-shell;
    enable = true;
  };

  programs.niri = {
    enable = true;
    package = pkgs.customPackages.niri-wrapped;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${lib.getExe pkgs.tuigreet} --time --cmd 'bash -l -c ${lib.getExe' pkgs.customPackages.niri-wrapped "niri-session"}'";
        user = "greeter";
      };
    };
  };

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
        ExecStart = "${lib.getExe pkgs.swayidle} -w timeout 300 '${lib.getExe pkgs.niri} msg action power-off-monitors' before-sleep '${lib.getExe pkgs.noctalia-shell} ipc call lockScreen lock'";
        Restart = "on-failure";
      };
    };
  };

  # https://github.com/YaLTeR/niri/wiki/Important-Software

  environment.systemPackages = with pkgs; [
    noctalia-shell
    adwaita-icon-theme
    # gnome-themes-extra
    nautilus
    wl-clipboard
  ];

  services.upower.enable = true;

  # enable polkit auth agent
  security.soteria.enable = true;

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
    "x-scheme-handler/http" = "chromium-browser.desktop";
    "x-scheme-handler/https" = "chromium-browser.desktop";
    "x-scheme-handler/ftp" = "chromium-browser.desktop";
    "x-scheme-handler/mailto" = "org.mozilla.thunderbird.desktop";
    "text/plain" = "Helix.desktop";
    "application/pdf" = "chromium-browser.desktop";
    # "image/png" = [
    #   "sxiv.desktop"
    #   "gimp.desktop"
    # ];
  };
}
