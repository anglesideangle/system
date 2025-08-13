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

  services.libinput.enable = true;
}
