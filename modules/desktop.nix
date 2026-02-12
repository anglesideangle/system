{
  lib,
  pkgs,
  ...
}:
{
  programs.niri.enable = true;

  systemd.user.services.noctalia-shell = {
    description = "Noctalia Shell - Wayland desktop shell";
    documentation = [ "https://docs.noctalia.dev/docs" ];
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    restartTriggers = [ pkgs.noctalia-shell ];

    environment = {
      PATH = lib.mkForce null;
    };

    serviceConfig = {
      ExecStart = lib.getExe pkgs.noctalia-shell;
      Restart = "on-failure";
    };
  };

  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings = {
      default_session = {
        command = "${lib.getExe pkgs.tuigreet} --time --cmd '${lib.getExe' pkgs.niri "niri-session"}'";
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

  # niri + noctalia config
  environment.etc."niri/config.kdl".text =
    let
      noctalia = "/run/current-system/sw/bin/noctalia-shell";
    in
    ''
      input {
          keyboard {
              xkb {
                  layout "us"
                  options "caps:escape"
              }
              repeat-delay 300
              repeat-rate 32
          }

          touchpad {
              // off
              // tap
              // dwt
              // dwtp
              // drag-lock
              natural-scroll
              // accel-speed 0.2
              accel-profile "adaptive"
              scroll-method "two-finger"
              click-method "clickfinger"
              scroll-factor 0.3
              // disabled-on-external-mouse
          }

          mouse {
              // off
              // natural-scroll
              // accel-speed 0.2
              // accel-profile "flat"
              // scroll-method "no-scroll"
          }

          trackpoint {
              // off
              // natural-scroll
              // accel-speed 0.2
              // accel-profile "flat"
              // scroll-method "on-button-down"
              // scroll-button 273
              // middle-emulation
          }
      }

      output "DP-4" {
          mode "2560x1440@60"

          scale 1.25

      }

      output "eDP-1" {
          // Uncomment this line to disable this output.
          // off

          // Resolution and, optionally, refresh rate of the output.
          // The format is "<width>x<height>" or "<width>x<height>@<refresh rate>".
          // If the refresh rate is omitted, niri will pick the highest refresh rate
          // for the resolution.
          // If the mode is omitted altogether or is invalid, niri will pick one automatically.
          // Run `niri msg outputs` while inside a niri instance to list all outputs and their modes.
          mode "2256x1504@60"

          // You can use integer or fractional scale, for example use 1.5 for 150% scale.
          scale 1.5

          // Transform allows to rotate the output counter-clockwise, valid values are:
          // normal, 90, 180, 270, flipped, flipped-90, flipped-180 and flipped-270.
          transform "normal"

          // Position of the output in the global coordinate space.
          // This affects directional monitor actions like "focus-monitor-left", and cursor movement.
          // The cursor can only move between directly adjacent outputs.
          // Output scale and rotation has to be taken into account for positioning:
          // outputs are sized in logical, or scaled, pixels.
          // For example, a 3840×2160 output with scale 2.0 will have a logical size of 1920×1080,
          // so to put another output directly adjacent to it on the right, set its x to 1920.
          // If the position is unset or results in an overlap, the output is instead placed
          // automatically.
          // position x=2048 y=0
      }

      output "DP-3" {
          // Uncomment this line to disable this output.
          // off

          // Resolution and, optionally, refresh rate of the output.
          // The format is "<width>x<height>" or "<width>x<height>@<refresh rate>".
          // If the refresh rate is omitted, niri will pick the highest refresh rate
          // for the resolution.
          // If the mode is omitted altogether or is invalid, niri will pick one automatically.
          // Run `niri msg outputs` while inside a niri instance to list all outputs and their modes.
          mode "2560x1440@60"

          // You can use integer or fractional scale, for example use 1.5 for 150% scale.
          scale 1.25

          // Transform allows to rotate the output counter-clockwise, valid values are:
          // normal, 90, 180, 270, flipped, flipped-90, flipped-180 and flipped-270.
          transform "normal"

          // Position of the output in the global coordinate space.
          // This affects directional monitor actions like "focus-monitor-left", and cursor movement.
          // The cursor can only move between directly adjacent outputs.
          // Output scale and rotation has to be taken into account for positioning:
          // outputs are sized in logical, or scaled, pixels.
          // For example, a 3840×2160 output with scale 2.0 will have a logical size of 1920×1080,
          // so to put another output directly adjacent to it on the right, set its x to 1920.
          // If the position is unset or results in an overlap, the output is instead placed
          // automatically.
          // position x=0 y=0
      }

      // Settings that influence how windows are positioned and sized.
      // Find more information on the wiki:
      // https://github.com/YaLTeR/niri/wiki/Configuration:-Layout
      layout {
          gaps 4

          center-focused-column "never"

          // You can customize the widths that "switch-preset-column-width" (Mod+R) toggles between.
          preset-column-widths {
              // Proportion sets the width as a fraction of the output width, taking gaps into account.
              // For example, you can perfectly fit four windows sized "proportion 0.25" on an output.
              // The default preset widths are 1/3, 1/2 and 2/3 of the output.
              proportion 0.33333
              proportion 0.5
              proportion 0.66667

              // Fixed sets the width in logical pixels exactly.
              // fixed 1920
          }

          // You can also customize the heights that "switch-preset-window-height" (Mod+Shift+R) toggles between.
          // preset-window-heights { }

          // You can change the default width of the new windows.
          default-column-width { proportion 0.5; }
          // If you leave the brackets empty, the windows themselves will decide their initial width.
          // default-column-width {}

          // By default focus ring and border are rendered as a solid background rectangle
          // behind windows. That is, they will show up through semitransparent windows.
          // This is because windows using client-side decorations can have an arbitrary shape.
          //
          // If you don't like that, you should uncomment `prefer-no-csd` below.
          // Niri will draw focus ring and border *around* windows that agree to omit their
          // client-side decorations.
          //
          // Alternatively, you can override it with a window rule called
          // `draw-border-with-background`.

          focus-ring {
            off
            width 1
          }

          border {
            on
            width 1
          }

          default-column-display "normal"
      }

      prefer-no-csd

      // You can change the path where screenshots are saved.
      // A ~ at the front will be expanded to the home directory.
      // The path is formatted with strftime(3) to give you the screenshot date and time.
      screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

      // You can also set this to null to disable saving screenshots to disk.
      // screenshot-path null

      // Animation settings.
      // The wiki explains how to configure individual animations:
      // https://github.com/YaLTeR/niri/wiki/Configuration:-Animations
      animations {
          // Uncomment to turn off all animations.
          // off

          // Slow down all animations by this factor. Values below 1 speed them up instead.
          slowdown 0.5
      }

      // Window rules let you adjust behavior for individual windows.
      // Find more information on the wiki:
      // https://github.com/YaLTeR/niri/wiki/Configuration:-Window-Rules

      window-rule {
          match app-id=r#""# title="^Picture in picture$"
          open-floating true
      }

      // Example: enable rounded corners for all windows.
      // (This example rule is commented out with a "/-" in front.)
      window-rule {
          geometry-corner-radius 4
          clip-to-geometry true
      }

      // Shadows behind floating windows
      window-rule {
        match is-floating=true
        shadow {
          on
        }
      }

      binds {
          // Keys consist of modifiers separated by + signs, followed by an XKB key name
          // in the end. To find an XKB name for a particular key, you may use a program
          // like wev.
          //
          // "Mod" is a special modifier equal to Super when running on a TTY, and to Alt
          // when running as a winit window.
          //
          // Most actions that you can bind here can also be invoked programmatically with
          // `niri msg action do-something`.

          // Mod-Shift-/, which is usually the same as Mod-?,
          // shows a list of important hotkeys.
          Mod+Shift+Slash { show-hotkey-overlay; }

          // Suggested binds for running programs: terminal, app launcher, screen locker.
          Mod+Return { spawn "alacritty"; }
          Mod+Shift+Return { spawn "chromium"; }

          // Core Noctalia binds
          Mod+D { spawn "${noctalia}" "ipc" "call" "launcher" "toggle"; }
          Mod+Space { spawn "${noctalia}" "ipc" "call" "launcher" "toggle"; }

          // Audio controls
          XF86AudioRaiseVolume { spawn "${noctalia}" "ipc" "call" "volume" "increase"; }
          XF86AudioLowerVolume { spawn "${noctalia}" "ipc" "call" "volume" "decrease"; }
          XF86AudioMute { spawn "${noctalia}" "ipc" "call" "volume" "muteOutput"; }

          // Brightness controls
          XF86MonBrightnessUp { spawn "${noctalia}" "ipc" "call" "brightness" "increase"; }
          XF86MonBrightnessDown { spawn "${noctalia}" "ipc" "call" "brightness" "decrease"; }

          Mod+Ctrl+Shift+Alt+L { spawn "chromium" "--new-window" "https://www.linkedin.com/"; }

          Mod+Q { close-window; }

          Mod+Left  { focus-column-left; }
          Mod+Down  { focus-window-down; }
          Mod+Up    { focus-window-up; }
          Mod+Right { focus-column-right; }
          Mod+H     { focus-column-left; }
          Mod+J     { focus-window-down; }
          Mod+K     { focus-window-up; }
          Mod+L     { focus-column-right; }

          Mod+Shift+Left  { move-column-left; }
          Mod+Shift+Down  { move-window-down; }
          Mod+Shift+Up    { move-window-up; }
          Mod+Shift+Right { move-column-right; }
          Mod+Shift+H     { move-column-left; }
          Mod+Shift+J     { move-window-down; }
          Mod+Shift+K     { move-window-up; }
          Mod+Shift+L     { move-column-right; }

          // Alternative commands that move across workspaces when reaching
          // the first or last window in a column.
          // Mod+J     { focus-window-or-workspace-down; }
          // Mod+K     { focus-window-or-workspace-up; }
          // Mod+Ctrl+J     { move-window-down-or-to-workspace-down; }
          // Mod+Ctrl+K     { move-window-up-or-to-workspace-up; }

          Mod+Home { focus-column-first; }
          Mod+End  { focus-column-last; }
          Mod+Shift+Home { move-column-to-first; }
          Mod+Shift+End  { move-column-to-last; }

          Mod+Control+Left  { focus-monitor-left; }
          Mod+Control+Down  { focus-monitor-down; }
          Mod+Control+Up    { focus-monitor-up; }
          Mod+Control+Right { focus-monitor-right; }
          Mod+Control+H     { focus-monitor-left; }
          Mod+Control+J     { focus-monitor-down; }
          Mod+Control+K     { focus-monitor-up; }
          Mod+Control+L     { focus-monitor-right; }

          Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
          Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
          Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
          Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
          Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
          Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
          Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
          Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }

          // Alternatively, there are commands to move just a single window:
          // Mod+Shift+Ctrl+Left  { move-window-to-monitor-left; }
          // ...

          // And you can also move a whole workspace to another monitor:
          // Mod+Shift+Ctrl+Left  { move-workspace-to-monitor-left; }
          // ...

          Mod+Page_Down      { focus-workspace-down; }
          Mod+Page_Up        { focus-workspace-up; }
          Mod+U              { focus-workspace-down; }
          Mod+I              { focus-workspace-up; }
          Mod+Shift+Page_Down { move-column-to-workspace-down; }
          Mod+Shift+Page_Up   { move-column-to-workspace-up; }
          Mod+Shift+U         { move-column-to-workspace-down; }
          Mod+Shift+I         { move-column-to-workspace-up; }

          // Alternatively, there are commands to move just a single window:
          // Mod+Ctrl+Page_Down { move-window-to-workspace-down; }
          // ...

          Mod+Ctrl+Page_Down { move-workspace-down; }
          Mod+Ctrl+Page_Up   { move-workspace-up; }
          Mod+Ctrl+U         { move-workspace-down; }
          Mod+Ctrl+I         { move-workspace-up; }

          Mod+S { toggle-overview; }

          // You can bind mouse wheel scroll ticks using the following syntax.
          // These binds will change direction based on the natural-scroll setting.
          //
          // To avoid scrolling through workspaces really fast, you can use
          // the cooldown-ms property. The bind will be rate-limited to this value.
          // You can set a cooldown on any bind, but it's most useful for the wheel.
          Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
          Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
          Mod+Shift+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
          Mod+Shift+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

          Mod+WheelScrollRight      { focus-column-right; }
          Mod+WheelScrollLeft       { focus-column-left; }
          Mod+Ctrl+WheelScrollRight { move-column-right; }
          Mod+Ctrl+WheelScrollLeft  { move-column-left; }

          // Usually scrolling up and down with Shift in applications results in
          // horizontal scrolling; these binds replicate that.
          Mod+Ctrl+WheelScrollDown      { focus-column-right; }
          Mod+Ctrl+WheelScrollUp        { focus-column-left; }
          Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
          Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

          // Similarly, you can bind touchpad scroll "ticks".
          // Touchpad scrolling is continuous, so for these binds it is split into
          // discrete intervals.
          // These binds are also affected by touchpad's natural-scroll, so these
          // example binds are "inverted", since we have natural-scroll enabled for
          // touchpads by default.

          // You can refer to workspaces by index. However, keep in mind that
          // niri is a dynamic workspace system, so these commands are kind of
          // "best effort". Trying to refer to a workspace index bigger than
          // the current workspace count will instead refer to the bottommost
          // (empty) workspace.
          //
          // For example, with 2 workspaces + 1 empty, indices 3, 4, 5 and so on
          // will all refer to the 3rd workspace.
          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+4 { focus-workspace 4; }
          Mod+5 { focus-workspace 5; }
          Mod+6 { focus-workspace 6; }
          Mod+7 { focus-workspace 7; }
          Mod+8 { focus-workspace 8; }
          Mod+9 { focus-workspace 9; }
          Mod+Shift+1 { move-column-to-workspace 1; }
          Mod+Shift+2 { move-column-to-workspace 2; }
          Mod+Shift+3 { move-column-to-workspace 3; }
          Mod+Shift+4 { move-column-to-workspace 4; }
          Mod+Shift+5 { move-column-to-workspace 5; }
          Mod+Shift+6 { move-column-to-workspace 6; }
          Mod+Shift+7 { move-column-to-workspace 7; }
          Mod+Shift+8 { move-column-to-workspace 8; }
          Mod+Shift+9 { move-column-to-workspace 9; }

          // Alternatively, there are commands to move just a single window:
          // Mod+Ctrl+1 { move-window-to-workspace 1; }

          // Switches focus between the current and the previous workspace.
          // Mod+Tab { focus-workspace-previous; }

          // The following binds move the focused window in and out of a column.
          // If the window is alone, they will consume it into the nearby column to the side.
          // If the window is already in a column, they will expel it out.
          Mod+BracketLeft  { consume-or-expel-window-left; }
          Mod+BracketRight { consume-or-expel-window-right; }

          // Consume one window from the right to the bottom of the focused column.
          Mod+Comma  { consume-window-into-column; }
          // Expel the bottom window from the focused column to the right.
          Mod+Period { expel-window-from-column; }

          Mod+R { switch-preset-column-width; }
          Mod+Shift+R { switch-preset-window-height; }
          Mod+Ctrl+R { reset-window-height; }
          Mod+F { maximize-column; }
          Mod+Shift+F { maximize-window-to-edges; }

          // Expand the focused column to space not taken up by other fully visible columns.
          // Makes the column "fill the rest of the space".
          Mod+Ctrl+F { expand-column-to-available-width; }

          Mod+C { center-column; }

          // Finer width adjustments.
          // This command can also:
          // * set width in pixels: "1000"
          // * adjust width in pixels: "-5" or "+5"
          // * set width as a percentage of screen width: "25%"
          // * adjust width as a percentage of screen width: "-10%" or "+10%"
          // Pixel sizes use logical, or scaled, pixels. I.e. on an output with scale 2.0,
          // set-column-width "100" will make the column occupy 200 physical screen pixels.
          Mod+Minus { set-column-width "-10%"; }
          Mod+Equal { set-column-width "+10%"; }

          // Finer height adjustments when in column with other windows.
          Mod+Shift+Minus { set-window-height "-10%"; }
          Mod+Shift+Equal { set-window-height "+10%"; }

          // Move the focused window between the floating and the tiling layout.
          Mod+V       { toggle-window-floating; }
          Mod+Shift+V { switch-focus-between-floating-and-tiling; }

          // Toggle tabbed column display mode.
          // Windows in this column will appear as vertical tabs,
          // rather than stacked on top of each other.
          Mod+W { toggle-column-tabbed-display; }

          // Actions to switch layouts.
          // Note: if you uncomment these, make sure you do NOT have
          // a matching layout switch hotkey configured in xkb options above.
          // Having both at once on the same hotkey will break the switching,
          // since it will switch twice upon pressing the hotkey (once by xkb, once by niri).
          // Mod+Space       { switch-layout "next"; }
          // Mod+Shift+Space { switch-layout "prev"; }

          Print { screenshot; }
          Ctrl+Print { screenshot-screen; }
          Alt+Print { screenshot-window; }
          Mod+P { screenshot; }
          Alt+Mod+P { screenshot-screen; }
          Shift+Mod+P { screenshot-window; }

          // Applications such as remote-desktop clients and software KVM switches may
          // request that niri stops processing the keyboard shortcuts defined here
          // so they may, for example, forward the key presses as-is to a remote machine.
          // It's a good idea to bind an escape hatch to toggle the inhibitor,
          // so a buggy application can't hold your session hostage.
          //
          // The allow-inhibiting=false property can be applied to other binds as well,
          // which ensures niri always processes them, even when an inhibitor is active.
          Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

          // The quit action will show a confirmation dialog to avoid accidental exits.
          Mod+Shift+E { quit; }
          Ctrl+Alt+Delete { quit; }

          // Powers off the monitors. To turn them back on, do any input like
          // moving the mouse or pressing any other key.
          // Mod+Shift+P { power-off-monitors; }
      }

      // noctalia settings
      layer-rule {
          match namespace="^quickshell-overview$"
          place-within-backdrop true
      }

      debug {
          honor-xdg-activation-with-invalid-serial
      }
    '';

  # https://github.com/YaLTeR/niri/wiki/Important-Software

  environment.systemPackages = with pkgs; [
    noctalia-shell
    adwaita-icon-theme
    nautilus
    wl-clipboard
  ];

  services.upower.enable = true;

  # enable polkit auth agent
  security.soteria.enable = true;

  # enable gnome keyring
  services.gnome.gnome-keyring.enable = true;

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

  # configure default editor
  environment.variables = {
    EDITOR = "${lib.getExe pkgs.customPackages.helix-wrapped}";
    # PAGER = "${lib.getExe pkgs.customPackages.helix-wrapped}";
    # MANPAGER = "${lib.getExe pkgs.customPackages.helix-wrapped}";
  };
}
