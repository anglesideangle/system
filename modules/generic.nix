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
    dates = "monthly";
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

  # zramSwap = {
  #   enable = true;
  #   algorithm = "zstd";
  # };
  boot.zswap.enable = true;

  services.dbus.implementation = "broker";

  # prevent freezing on high loads
  services.irqbalance.enable = true;

  # latest (lts) kernel?
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.fwupd.enable = true;

  users.mutableUsers = false;
  services.userborn.enable = true;

  hardware.graphics.enable = true;

  services.kmscon.enable = true;

  programs.nh = {
    enable = true;
    flake = "/var/nixos";
  };
}
