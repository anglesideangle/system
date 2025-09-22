
{
  lib,
  pkgs,
  packages,
  ...
}:
{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.gnome.core-apps.enable = true;
  services.gnome.core-os-services.enable = true;

  # gnome settings
  #
  # WIP
  programs.dconf.profiles.user.databases = [
    {
      lockAll = true;
      settings = {
        "org/gnome/desktop/interface" = {
          accent-color = "blue";
          color-scheme = "prefer-dark";
        };

        "org/gnome/mutter" = {
          experimental-features = [
            "scale-monitor-framebuffer"
            "xwayland-native-scaling"
          ];
        };

        # "org/gnome/desktop/default-applications" = {
          
        # };

# org.gnome.desktop.default-applications.office.calendar exec 'evolution -c calendar'
# org.gnome.desktop.default-applications.office.calendar needs-term false
# org.gnome.desktop.default-applications.office.tasks exec 'evolution -c tasks'
# org.gnome.desktop.default-applications.office.tasks needs-term false
# org.gnome.desktop.default-applications.terminal exec 'gnome-terminal'
# org.gnome.desktop.default-applications.terminal exec-arg '-x'


        "org/gnome/desktop/input-sources" = {
          xkb-options = [
            "caps:escape"
          ];
        };

        "org/gnome/desktop/wm/keybindings" = with lib.gvariant; {
          close = [ "<Super>Q" ];

          cycle-windows = ["<Super>Tab"];
          cycle-windows-backward = ["<Super><Shift>Tab"];
          switch-applications = mkEmptyArray type.string;
          switch-applications-backward = mkEmptyArray type.string;
          toggle-overview = ["<Super>D"];

          # move-to-monitor-down = ["<Super><Shift>Down"];
          # move-to-monitor-left = ["<Super><Shift>Left"];
          # move-to-monitor-right = ["<Super><Shift>Right"];
          # move-to-monitor-up = ["<Super><Shift>Up"];

          move-to-workspace-1 = ["<Super><Shift>1"];
          move-to-workspace-2 = ["<Super><Shift>2"];
          move-to-workspace-3 = ["<Super><Shift>3"];
          move-to-workspace-4 = ["<Super><Shift>4"];
          move-to-workspace-5 = ["<Super><Shift>5"];
          move-to-workspace-6 = ["<Super><Shift>6"];
          move-to-workspace-7 = ["<Super><Shift>7"];
          move-to-workspace-8 = ["<Super><Shift>8"];
          move-to-workspace-9 = ["<Super><Shift>9"];
          move-to-workspace-10 = ["<Super><Shift>0"];
          # move-to-workspace-11 = [];
          # move-to-workspace-12 = [];

          move-to-workspace-left = [ "<Super><Shift>U" "<Super><Shift>Page_Up" "<Super><Shift><Alt>Left" "<Control><Shift><Alt>Left"];
          move-to-workspace-right = [ "Super><Shift>I" "<Super><Shift>Page_Down" "<Super><Shift><Alt>Right" "<Control><Shift><Alt>Right"];


          switch-to-workspace-1 = ["<Super>1"];
          switch-to-workspace-2 = ["<Super>2"];
          switch-to-workspace-3 = ["<Super>3"];
          switch-to-workspace-4 = ["<Super>4"];
          switch-to-workspace-5 = ["<Super>5"];
          switch-to-workspace-6 = ["<Super>6"];
          switch-to-workspace-7 = ["<Super>7"];
          switch-to-workspace-8 = ["<Super>8"];
          switch-to-workspace-9 = ["<Super>9"];
          switch-to-workspace-10 = ["<Super>0"];
          # switch-to-workspace-11 = [];
          # switch-to-workspace-12 = [];

          switch-to-application-1 = mkEmptyArray type.string;
          switch-to-application-2 = mkEmptyArray type.string;
          switch-to-application-3 = mkEmptyArray type.string;
          switch-to-application-4 = mkEmptyArray type.string;
          switch-to-application-5 = mkEmptyArray type.string;
          switch-to-application-6 = mkEmptyArray type.string;
          switch-to-application-7 = mkEmptyArray type.string;
          switch-to-application-8 = mkEmptyArray type.string;
          switch-to-application-9 = mkEmptyArray type.string;


          switch-to-workspace-left = ["<Super>U" "<Super>Page_Up" "<Super><Alt>Left" "<Control><Alt>Left"];
          switch-to-workspace-right = ["<Super>I" "<Super>Page_Down" "<Super><Alt>Right" "<Control><Alt>Right"];

          maximize = [ "<Super>K" ];
          unmaximize = [ "<Super>J" ];
          toggle-tiled-left = [ "<Super>H" ];
          toggle-tiled-right = [ "<Super>L" ];

        };

        "org/gnome/settings-daemon/plugins/custom-keybindings/custom0" = {
          binding = "<Super>Enter";
          command = "${lib.getExe packages.ghostty-wrapped}";
          name = "Terminal";
        };

      };
    }
  ];
}
