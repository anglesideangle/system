{
  pkgs,
  packages,
  ...
}:
{
  services.flatpak.enable = true;
  
  # set up chromium config for pwas
  programs.chromium = {
    enable = true;
    extensions = [
      # "ddkjiahejlhfcafbddmgiahcphecmpfh" # ublock origin lite
      "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${pkgs.ungoogled-chromium.version}&x=id%3Dddkjiahejlhfcafbddmgiahcphecmpfh%26installsource%3Dondemand%26uc"
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

  users.users.asa.packages = with pkgs; [
    packages.alacritty-wrapped
    packages.helix-wrapped

    aerc
    yazi
    wget
    ungoogled-chromium

    fzf
    ripgrep

    # utilities
    zip
    unzip
    zathura
    btop

    # vpn stuff
    # (globalprotect-openconnect.overrideAttrs rec {
    #   version = "2.4.5";
    #   src = fetchurl {
    #     url = "https://github.com/yuezk/GlobalProtect-openconnect/releases/download/v${version}/globalprotect-openconnect-${version}.tar.gz";
    #     hash = "sha256-ACeNZpHxSK+LkhxuSMOHjuLj5SK82WCOh53+Ai/NQFA=";
    #   };
    #   patchPhase = "";

    # })
  ];

}
