{
  lib,
  pkgs,
  ...
}:
{
  system.tools.nixos-generate-config.enable = lib.mkDefault false;
  # environment.defaultPackages = lib.mkDefault [ ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
      "ca-derivations"
      "auto-allocate-uids"
    ];
    trusted-users = [ "root" ];
    allowed-users = [ "@wheel" ];
    auto-optimise-store = true;
    pure-eval = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
  };

  nix.channel.enable = false;

  hardware.enableAllFirmware = false;
  hardware.enableAllHardware = false;
  hardware.enableRedistributableFirmware = true;

  documentation.man = {
    enable = true;
    man-db.enable = false;
    mandoc.enable = true;
  };

  security.sudo.enable = false;

  # security.lockKernelModules = true;
  # ^ breaks a lot of stuff
  security.protectKernelImage = true;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  services.dbus.implementation = "broker";

  # prevent freezing on high loads
  services.irqbalance.enable = true;

  # latest (lts) kernel?
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.fwupd.enable = true;

  # User accounts
  users.mutableUsers = false;
  systemd.sysusers.enable = true;
  users.allowNoPasswordLogin = true;
  services.homed = {
    enable = true;
    settings.Home = {
      DefaultFileSystemType = "btrfs";
      DefaultStorage = "luks";
    };
  };

  environment.systemPackages = [ pkgs.nushell ];
  environment.shells = [ pkgs.nushell ];

  hardware.graphics.enable = true;

  programs.nh = {
    enable = true;
    flake = "/var/nixos";
  };
}
