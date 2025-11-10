{
  lib,
  pkgs,
  config,
  modulesPath,
  ...
}:
{
  # imports = [ "${modulesPath}/profiles/perlless.nix" ];
  # stuff to remove perl
  # system.disableInstallerTools = true;
  system.tools.nixos-generate-config.enable = lib.mkDefault false;
  environment.defaultPackages = lib.mkDefault [ ];
  # documentation.info.enable = lib.mkDefault false;
  # documentation.nixos.enable = lib.mkDefault false;


  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
      "ca-derivations"
    ];
    trusted-users = [ "root" ];
    allowed-users = [ "@wheel" ];
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
  };

  # nix.optimise = {
  #   automatic = true;
  #   dates = "daily";
  # };

  # improve laptop responsiveness during rebuilds
  # nix.daemonCPUSchedPolicy = "idle";

  # nix.channel.enable = false;
  # nix.nixPath = [ "nixpkgs=/etc/nixos/nixpkgs" ];

  # environment.etc = {
  #   "nixos/nixpkgs".source = builtins.storePath pkgs.path;
  # };

  hardware.enableRedistributableFirmware = true;

  documentation.man = {
    enable = true;
    man-db.enable = false;
    mandoc.enable = true;
  };

  # nixpkgs.hostPlatform = {
  #   system = "x86_64-linux";
  #   gcc.arch = "znver4";
  #   gcc.tune = "znver4";
  # };

  security.sudo.enable = false;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 4;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.systemd.enable = true;

  system.etc.overlay = {
    enable = true;
    mutable = true;
  };

  boot.tmp.cleanOnBoot = true;
  boot.tmp.useTmpfs = true;
  systemd.services.nix-daemon = {
    environment.TMPDIR = "/var/tmp";
  };

  security.lockKernelModules = true;
  security.protectKernelImage = true;

  # will break / experimental
  systemd.enableStrictShellChecks = true;

  # i wonder if this is a good idea
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  services.dbus.implementation = "broker";

  # prevent freezing on high loads
  services.irqbalance.enable = true;
  services.earlyoom.enable = true;

  programs.nh = {
    enable = true;
    flake = "/home/asa/system";
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # latest (lts) kernel?
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # hardware.framework.enableKmod = false;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # For framework
  services.fwupd.enable = true;

  # User accounts
  # users.mutableUsers = false;
  services.userborn.enable = true;
  users.users.asa = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "kvm"
      "dialout"
    ];
  };

  hardware.graphics.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
