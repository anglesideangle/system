# additional @args needed to forward systemdSupport to mkWrapper
{
  pkgs,
  lib,
  mkWrapper,
  theme,
  waybar,
  pavucontrol,
  networkmanagerapplet,
  ...
}@args:
let
  cfg = pkgs.writeText "config.jsonc" ''
    {
        "layer": "top", // Waybar at top layer
        // "position": "bottom", // Waybar position (top|bottom|left|right)
        "height": 26, // Waybar height (to be removed for auto height)
        // "width": 1280, // Waybar width
        "spacing": 4, // Gaps between modules (4px)
        "margin-top": 4,
        "margin-left": 4,
        "margin-right": 4,

        "modules-left": [
            "niri/workspaces"
        ],

        "modules-center": [
            "niri/window"
        ],

        "modules-right": [
            // "mpd",
            // "idle_inhibitor",
            // "power-profiles-daemon",
            // "cpu",
            // "memory",
            // "temperature",
            // "backlight",
            // "keyboard-state",
            // "sway/language",
            "pulseaudio",
            "network",
            "battery",
            // "battery#bat2",
            "clock",
            "tray"
        ],

        "sway/mode": {
            "format": "<span style=\"italic\">{}</span>"
        },

        "sway/scratchpad": {
            "format": "{icon} {count}",
            "show-empty": false,
            "format-icons": ["", ""],
            "tooltip": true,
            "tooltip-format": "{app}: {title}"
        },

        "mpd": {
            "format": "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ",
            "format-disconnected": "Disconnected ",
            "format-stopped": "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ",
            "unknown-tag": "N/A",
            "interval": 5,
            "consume-icons": {
                "on": " "
            },
            "random-icons": {
                "off": "<span color=\"#f53c3c\"></span> ",
                "on": " "
            },
            "repeat-icons": {
                "on": " "
            },
            "single-icons": {
                "on": "1 "
            },
            "state-icons": {
                "paused": "",
                "playing": ""
            },
            "tooltip-format": "MPD (connected)",
            "tooltip-format-disconnected": "MPD (disconnected)"
        },
        "idle_inhibitor": {
            "format": "{icon}",
            "format-icons": {
                "activated": "",
                "deactivated": ""
            }
        },
        "tray": {
            "icon-size": 16,
            "spacing": 10
        },
        "clock": {
            "format": "{:%H:%M}",
            "format-alt": "{:%A, %B %d, %R}",
            "tooltip-format": "<tt><small>{calendar}</small></tt>",
            "calendar": {
                        "mode"          : "year",
                        "mode-mon-col"  : 3,
                        "on-scroll"     : 1,
                        "format": {
                                  "months":     "<span color='#ffead3'><b>{}</b></span>",
                                  "days":       "<span color='#ecc6d9'><b>{}</b></span>",
                                  "weeks":      "<span color='#99ffdd'><b>W{}</b></span>",
                                  "weekdays":   "<span color='#ffcc66'><b>{}</b></span>",
                                  "today":      "<span color='#ff6699'><b><u>{}</u></b></span>"
                                  }
                        },
            "actions":  {
                        "on-click-right": "mode",
                        "on-scroll-up": "tz_up",
                        "on-scroll-down": "tz_down",
                        "on-scroll-up": "shift_up",
                        "on-scroll-down": "shift_down"
                        }
        },
        "cpu": {
            "format": "{usage}% ",
            "tooltip": false
        },
        "memory": {
            "format": "{}% "
        },
        "temperature": {
            // "thermal-zone": 2,
            // "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input",
            "critical-threshold": 80,
            // "format-critical": "{temperatureC}°C {icon}",
            "format": "{temperatureC}°C {icon}",
            "format-icons": ["", "", ""]
        },
        "backlight": {
            // "device": "acpi_video1",
            "format": "{percent}% {icon}",
            "format-icons": ["", "", "", "", "", "", "", "", ""]
        },
        "battery": {
            "states": {
                "good": 95,
                "warning": 30,
                "critical": 15
            },
            "format": "{capacity}%  {icon} ",
            "format-full": "{capacity}%  {icon} ",
            "format-charging": "{capacity}%  ",
            "format-plugged": "{capacity}%  ",
            "format-alt": "{time}  {icon}",
            "format-icons": ["", "", "", "", ""]
        },
        "power-profiles-daemon": {
          "format": "{icon}",
          "tooltip-format": "Power profile: {profile}\nDriver: {driver}",
          "tooltip": true,
          "format-icons": {
            "default": "",
            "performance": "",
            "balanced": "",
            "power-saver": ""
          }
        },
        "network": {
            // "interface": "wlp2*", // (Optional) To force the use of this interface
            // "format-wifi": "{essid}  ({signalStrength}%)   ",
            "format-wifi": "{signalStrength}%   ",
            "format-ethernet": "{ipaddr}/{cidr}  ",
            "tooltip-format": "{ifname} via {gwaddr}  ",
            "format-linked": "{ifname} (No IP)  ",
            "format-disconnected": "Disconnected  ⚠",
            // "format-alt": "{ifname}: {ipaddr}/{cidr}",
            "on-click": "${lib.getExe' networkmanagerapplet "nm-connection-editor"}"
        },
        "pulseaudio": {
            "scroll-step": 1, // %, can be a float
            "format": "{volume}%  {icon}   {format_source}",
            "format-bluetooth": "{volume}% {icon}   {format_source}",
            "format-bluetooth-muted": "{icon}   {format_source}",
            "format-muted": "{format_source}",
            "format-source": "{volume}%  ",
            "format-source-muted": "",
            "format-icons": {
                "headphone": "",
                "hands-free": "",
                "headset": "",
                "phone": "",
                "portable": "",
                "car": "",
                "default": ["", "", ""]
            },
            "on-click": "${lib.getExe pavucontrol}"
        },
        "custom/media": {
            "format": "{icon} {}",
            "return-type": "json",
            "max-length": 40,
            "format-icons": {
                "spotify": "",
                "default": "🎜"
            },
            "escape": true,
            "exec": "$HOME/.config/waybar/mediaplayer.py 2> /dev/null" // Script in resources folder
            // "exec": "$HOME/.config/waybar/mediaplayer.py --player spotify 2> /dev/null" // Filter player based on name
        },
        "custom/power": {
            "format" : "⏻ ",
    		"tooltip": false,
    		"menu": "on-click",
    		"menu-file": "$HOME/.config/waybar/power_menu.xml", // Menu file in resources folder
    		"menu-actions": {
    			"shutdown": "shutdown",
    			"reboot": "reboot",
    			"suspend": "systemctl suspend",
    			"hibernate": "systemctl hibernate"
    		}
        }
    }
  '';
  style = pkgs.writeText "style.css" ''
    * {
        font-family: "sans-serif", "Noto Monochrome Emoji", "Font Awesome 5 Pro Solid", "Font Awesome 5 Brands";
        font-size: ${theme.lengths.font-md}px;
        font-weight: 600;
        color: #${theme.colors.fg-regular};
    }

    /* Reset styling for buttons */
    button {
        all: unset;
    }

    window#waybar {
        background: transparent;
    }

    #workspaces button.focused,
    #workspaces button:hover {
        border-color: #${theme.colors.cyan};
    }

    #workspaces button.urgent {
        border-color: #${theme.colors.red};
    }

    #mode,
    #clock,
    #battery,
    #cpu,
    #memory,
    #disk,
    #temperature,
    #backlight,
    #network,
    #pulseaudio,
    #wireplumber,
    #custom-media,
    #tray,
    #mode,
    #idle_inhibitor,
    #scratchpad,
    #power-profiles-daemon,
    #mpd,
    #window,
    #workspaces button {
        padding: 4px 8px;
        background-color: #${theme.colors.bg-regular};
        border-style: solid;
        border-width: ${theme.lengths.border-width}px;
        border-radius: ${theme.lengths.border-radius}px;
        border-color: #${theme.colors.gray};
    }

    /* Add spacing in between each workspace button */
    #workspaces button {
        margin-right: 4px;
    }

    /* Prevent duplicated margin from rightmost workspace button */
    #workspaces button:last-child {
        margin-right: 0;
    }

    #waybar.empty #window {
        background-color: transparent;
        border-width: 0px
    }

    #clock {
        color: #${theme.colors.purple};
    }

    #clock:hover {
        border-color: #${theme.colors.purple};
    }

    #battery {
        color: #${theme.colors.green};
    }

    #battery:hover {
        border-color: #${theme.colors.green};
    }

    #battery.charging {
        border-color: #${theme.colors.green};
    }

    @keyframes blink {
        to {
            border-color: #${theme.colors.red};
        }
    }

    /* Using steps() instead of linear as a timing function to limit cpu usage */
    #battery.critical:not(.charging) {
        color: #${theme.colors.red};
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: steps(12);
        animation-iteration-count: infinite;
        animation-direction: alternate;
    }

    #network {
        color: #${theme.colors.blue};
    }

    #network:hover {
        border-color: #${theme.colors.blue};
    }

    #network.disconnected {
        border-color: #${theme.colors.red};
    }

    #pulseaudio {
        color: #${theme.colors.yellow};
    }

    #pulseaudio:hover {
        border-color: #${theme.colors.yellow};
    }

    #pulseaudio.muted {
        border-color: #${theme.colors.red};
    }
  '';
  passThruArgs = builtins.removeAttrs args [
    "pkgs"
    "lib"
    "mkWrapper"
    "theme"
    "waybar"
    "pavucontrol"
    "networkmanagerapplet"
  ];
in
mkWrapper {
  pkg = waybar.override passThruArgs;
  waybar.prependFlags = [
    "--config"
    "${cfg}"
    "--style"
    "${style}"
  ];
}
