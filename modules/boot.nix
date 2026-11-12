{ lib, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.sbctl ];

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    configurationLimit = 4;
    measuredBoot = {
      enable = true;
      pcrs = [
        0
        4
        7
      ];
      autoCryptenroll = {
        enable = true;
        device = "/dev/disk/by-label/luks";
      };
    };
    autoGenerateKeys.enable = true;
    autoEnrollKeys = {
      enable = true;
      autoReboot = true;
    };
  };

  boot.supportedFilesystems = lib.mkForce [
    "btrfs"
    "vfat"
  ];

  boot.loader.efi.canTouchEfiVariables = true;

  system.nixos-init.enable = true;

  system.etc.overlay = {
    enable = true;
    mutable = false;
  };

  boot.tmp.cleanOnBoot = true;
  boot.tmp.useTmpfs = true;
  systemd.services.nix-daemon = {
    environment.TMPDIR = "/var/tmp";
  };
}
