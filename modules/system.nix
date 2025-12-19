{
  lib,
  pkgs,
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
      "auto-allocate-uids"
    ];
    trusted-users = [ "root" ];
    allowed-users = [ "@wheel" ];
    auto-optimise-store = true;
  };

  # nix.gc = {
  #   automatic = true;
  #   dates = "weekly";
  # };

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

  # hardware.enableAllFirmware = true;
  # hardware.enableAllHardware = true;
  # hardware.enableRedistributableFirmware = true;

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

  # agressively optimize rust packages
  #
  # this is done because safe rust is assumed to avoid UB within the rust
  # compiler's vm model, and unsafe rust must be extensively validated against
  # miri or formally verified to not violate the assumptions of this vm
  #
  # the same guarantees cannot be made for c or c++
  # nixpkgs.overlays = [
  #   (final: prev: {
  #     rustPlatform = prev.rustPlatform // {
  #       buildRustPackage = args: prev.rustPlatform.buildRustPackage (args // {
  #         # Append the aggressive flags to any existing RUSTFLAGS
  #         RUSTFLAGS = (args.RUSTFLAGS or "") + " -C lto=fat -C codegen-units=1 -C target-cpu=native -C opt-level=3";
  #       });
  #     };
  #   })
  # ];

  security.sudo.enable = false;

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot = {
  #   enable = true;
  #   configurationLimit = 4;
  # };
  environment.systemPackages = [
    pkgs.sbctl
    pkgs.nushell # TODO
  ];
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    configurationLimit = 4;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.systemd.enable = true;
  system.nixos-init.enable = true; # bashless init

  system.etc.overlay = {
    enable = true;
    mutable = true;
  };

  boot.tmp.cleanOnBoot = true;
  boot.tmp.useTmpfs = true;
  systemd.services.nix-daemon = {
    environment.TMPDIR = "/var/tmp";
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  security.lockKernelModules = true;
  security.protectKernelImage = true;

  # will break / experimental
  # systemd.enableStrictShellChecks = true;

  # i wonder if this is a good idea
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  services.dbus.implementation = "broker";

  # prevent freezing on high loads
  services.irqbalance.enable = true;
  services.earlyoom.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # latest (lts) kernel?
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # hardware.framework.enableKmod = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # For framework
  services.fwupd.enable = true;

  # User accounts
  users.mutableUsers = false;
  users.allowNoPasswordLogin = true;
  systemd.sysusers.enable = true;
  services.homed = {
    enable = true;
    settings.Home = {
      DefaultFileSystemType = "btrfs";
      DefaultStorage = "luks";
    };
  };

  environment.shells = [ pkgs.nushell ];

  hardware.graphics.enable = true;

  programs.nh = {
    enable = true;
    flake = "/home/asa/system";
  };

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
  system.stateVersion = "25.05"; # Did you read the comment?
}
