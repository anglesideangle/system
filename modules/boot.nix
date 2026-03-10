{ pkgs }:
{
  environment.systemPackages = [
    pkgs.sbctl
    pkgs.nushell
  ];

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    configurationLimit = 4;
    autoGenerateKeys.enable = true;
    autoEnrollKeys = {
      enable = true;
      autoReboot = true;
    };
  };

  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.systemd.enable = true;
  system.nixos-init.enable = true;

  boot.tmp.cleanOnBoot = true;
  boot.tmp.useTmpfs = true;
  systemd.services.nix-daemon = {
    environment.TMPDIR = "/var/tmp";
  };
}
