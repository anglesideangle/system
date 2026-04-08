{ lib, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.sbctl ];

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    configurationLimit = 8;
    autoGenerateKeys.enable = true;
    autoEnrollKeys = {
      enable = true;
      autoReboot = true;
    };
  };

  boot.supportedFilesystems = lib.mkForce [ "btrfs" "vfat" ];

  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.systemd.enable = true;
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
