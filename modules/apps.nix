{
  pkgs,
  packages,
  ...
}:
{
  services.flatpak.enable = true;

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
      default = [ "com.mitchellh.ghostty.desktop" ];
    };
  };

  xdg.mime.defaultApplications = {
    "x-scheme-handler/http" = "org.mozilla.firefox.desktop";
    "x-scheme-handler/https" = "org.mozilla.firefox.desktop";
    "x-scheme-handler/ftp" = "org.mozilla.firefox.desktop";
    "x-scheme-handler/mailto" = "org.mozilla.thunderbird.desktop";
    "text/plain" = "Helix.desktop";
    "application/pdf" = "org.mozilla.firefox.desktop";
    # "image/png" = [
    #   "sxiv.desktop"
    #   "gimp.desktop"
    # ];
  };

  # set up chromium config for pwas
  programs.chromium = {
    enable = true;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
    ];
    extraOpts = {
      "BrowserSignin" = 0;
      "SyncDisabled" = true;
      "PasswordManagerEnabled" = false;
      "SpellcheckEnabled" = true;
      "SpellcheckLanguage" = [ "en-US" ];
    };
  };

  # Tell electron apps / chromium to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  users.users.asa.packages = with pkgs; [
    packages.ghostty-wrapped
    packages.helix-wrapped
    packages.mako-wrapped
    packages.fuzzel-wrapped
    wl-clipboard
    # delete later
    xwayland-satellite

    yazi
    wget
    docker-compose
    ungoogled-chromium

    alacritty

    # utilities
    zip
    unzip
    zathura
    btop

    # vpn stuff
    networkmanager-openconnect
    globalprotect-openconnect

    # stuff that should be wrapped with helix
    nixd
    pyright
    rust-analyzer
    llvmPackages_19.clang-tools
    nixfmt-rfc-style

    # gnome core apps
    adwaita-icon-theme
    nautilus
  ];

}
