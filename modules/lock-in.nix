{ lib, pkgs, ... }:

let
  blockedDomains = [
    "youtube.com"
    "www.youtube.com"
    "youtu.be"
    "googlevideo.com"
    "discord.com"
    "x.com"
    "bsky.app"
    "reddit.com"
    "discourse.ros.org"
    "discourse.nixos.org"
  ];

  resolvedConf = ''
    [Resolve]
    ${pkgs.lib.concatMapStringsSep "\n" (d: "Domains=~${d}") blockedDomains}
    DNS=127.0.0.1
  '';
in
{
  imports = [
    ./networking.nix
    ./desktop.nix
  ];

  environment.etc."focus-mode/block-domains.conf".text = resolvedConf;

  systemd.services.focus-mode = {
    description = "Block selected domains via systemd-resolved";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;

      ExecStart = [
        "${pkgs.coreutils}/bin/mkdir -p /run/systemd/resolved.conf.d"
        "${pkgs.coreutils}/bin/ln -sf /etc/focus-mode/block-domains.conf /run/systemd/resolved.conf.d/block-domains.conf"
        # "noctalia-shell ipc call notifications enableDND"
      ];

      ExecStop = [
        "${pkgs.coreutils}/bin/rm -f /run/systemd/resolved.conf.d/block-domains.conf"
        "${pkgs.systemd}/bin/systemctl restart systemd-resolved"
        # "noctalia-shell ipc call notifications disableDND"
      ];
    };
  };

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "focus-mode" ''
      set -e

      case "$1" in
        on)
          exec systemctl start focus-mode
          ;;
        off)
          exec systemctl stop focus-mode
          ;;
        toggle|"")
          if systemctl is-active --quiet focus-mode; then
            exec systemctl stop focus-mode
          else
            exec systemctl start focus-mode
          fi
          ;;
        *)
          echo "usage: focus-mode [on|off|toggle]" >&2
          exit 1
          ;;
      esac
    '')
    (pkgs.makeDesktopItem {
      name = "focus";
      desktopName = "Focus";
      comment = "Toggle access to distracting websites and DND";
      exec = "focus toggle";
    })
  ];
}
