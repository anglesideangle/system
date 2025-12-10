{
  lib,
  pkgs,
  ...
}:
# set up chromium web "apps"
let
  webapps =
    let
      apps = {
        Discord = "https://discord.com/channels/@me";
        Slack = "https://app.slack.com/client/";
        Outlook = "https://outlook.office.com/mail/";
        Gmail = "http://mail.google.com/mail/u/0/";
        "Google Calendar" = "https://calendar.google.com/calendar/u/0/";
        Bluesky = "https://bsky.app/";
        Canvas = "https://canvas.mit.edu/";
        Gradescope = "https://www.gradescope.com/";
      };
    in
    lib.mapAttrsToList (
      name: url:
      pkgs.makeDesktopItem {
        inherit name;
        desktopName = name;
        exec = "${lib.getExe pkgs.customPackages.chromium-wrapped} --app=${url} --no-first-run --no-default-browser-check";
        terminal = false;
      }
    ) apps;
in
{
  services.flatpak.enable = true;

  systemd.user.services.alacritty = {
    description = "Alacritty Daemon";
    wantedBy = [ "graphical.target" ];
    serviceConfig = {
      ExecStart = "${lib.getExe pkgs.customPackages.alacritty-wrapped} --daemon";
      Restart = "on-failure";
    };
  };

  programs.chromium = {
    enable = true;

    # extensions = [
    #   "ddkjiahejlhfcafbddmgiahcphecmpfh" # ublock origin lite
    #   "nngceckbapebfimnlniiiahkandclblb" # bitwarden
    # ];

    # https://github.com/RKNF404/chromium-hardening-guide/blob/main/configs/POLICIES.md
    extraOpts = {
      "AIModeSettings" = 1;
      "AlternateErrorPagesEnabled" = false;
      # "AudioSandboxEnabled" = true;
      "AutofillAddressEnabled" = false;
      "AutofillCreditCardEnabled" = false;
      "AutofillPredictionSettings" = 2;
      "AutomatedPasswordChangeSettings" = 2;
      "BackgroundModeEnabled" = false;
      "BlockExternalExtensions" = true;
      "BlockThirdPartyCookies" = true;
      "BrowserLabsEnabled" = false;
      "BrowserSignin" = 0;
      "BuiltInAIAPIsEnabled" = false;
      "ChromeVariations" = 2;
      "ClearBrowsingDataOnExitList" = [
        "download_history"
        "cached_images_and_files"
        "autofill"
        "hosted_app_data"
      ];
      "ClickToCallEnabled" = false;
      "CloudPrintProxyEnabled" = false;
      "CreateThemesSettings" = 2;
      "DefaultBrowserSettingEnabled" = false;
      # "DefaultJavaScriptJitSetting" = 2;
      # "DefaultJavaScriptOptimizerSetting" = 1;
      "DefaultSensorsSetting" = 2;
      "DefaultWebUsbGuardSetting" = 2;
      "DesktopSharingHubEnabled" = false;
      "DevToolsGenAiSettings" = 2;
      # "Disable3DAPIs" = true;
      "DnsOverHttpsMode" = "automatic";
      # "DnsOverHttpsTemplates"
      "EnableMediaRouter" = false;
      "ExtensionAllowedTypes" = [
        "extension"
        "theme"
      ];
      "ExtensionDeveloperModeSettings" = 1;
      # "ExtensionInstallAllowlist" = []; # TODO
      # "ExtensionInstallBlocklist" = [
      #   "ddkjiahejlhfcafbddmgiahcphecmpfh" # ublock origin lite
      #   "nngceckbapebfimnlniiiahkandclblb" # bitwarden
      # ];
      "ExtensionSettings" = {
        "*" = {
          "installation_mode" = "blocked";
        };
        "ddkjiahejlhfcafbddmgiahcphecmpfh" = {
          "installation_mode" = "force_installed";
          "update_url" = "https://clients2.google.com/service/update2/crx";
        };
        "nngceckbapebfimnlniiiahkandclblb" = {
          "installation_mode" = "force_installed";
          "update_url" = "https://clients2.google.com/service/update2/crx";
        };
      };

      "GeminiSettings" = 1;
      "GenAILocalFoundationalModelSettings" = 1;
      "GoogleSearchSidePanelEnabled" = false;
      "HardwareAccelerationModeEnabled" = true; # recommended to be false
      "HelpMeWriteSettings" = 2;
      "HistoryClustersVisible" = false;
      "HistorySearchSettings" = 2;
      "HttpsOnlyMode" = "force_enabled";
      "LensOverlaySettings" = 1;
      "LensRegionSearchEnabled" = false;
      "LiveTranslateEnabled" = false;
      "MediaRecommendationsEnabled" = false;
      "MetricsReportingEnabled" = false;
      "NativeMessagingBlocklist" = [ "*" ];
      "NetworkPredictionOptions" = 2;
      "NetworkServiceSandboxEnabled" = true;
      "NTPCardsVisible" = false;
      "PasswordLeakDetectionEnabled" = false;
      "PasswordManagerEnabled" = false;
      "PaymentMethodQueryEnabled" = false;
      "PrivacySandboxAdMeasurementEnabled" = false;
      "PrivacySandboxAdTopicsEnabled" = false;
      "PrivacySandboxPromptEnabled" = false;
      "PrivacySandboxSiteEnabledAdsEnabled" = false;
      "PromotionsEnabled" = false;
      "PromptForDownloadLocation" = true; # TODO ??
      # "ProtectedContentIdentifiersAllowed" = false;
      "RelatedWebsiteSetsEnabled" = false;
      "RemoteAccessHostAllowRemoteAccessConnections" = false;
      "RemoteAccessHostAllowRemoteSupportConnections" = false;
      "RemoteAccessHostFirewallTraversal" = false;
      "RemoteDebuggingAllowed" = false;
      "SafeBrowsingDeepScanningEnabled" = false;
      "SafeBrowsingExtendedReportingEnabled" = false;
      "SafeBrowsingProtectionLevel" = 1;
      "SafeBrowsingSurveysEnabled" = false;
      "SearchSuggestEnabled" = false;
      "SharedClipboardEnabled" = false;
      "ShoppingListEnabled" = false;
      "ShowFullUrlsInAddressBar" = true;
      "SitePerProcess" = true;
      "SpellCheckServiceEnabled" = false;
      "SyncDisabled" = true;
      "TabCompareSettings" = 2;
      "TLS13EarlyDataEnabled" = false;
      "TranslateEnabled" = false;
      "TranslatorAPIAllowed" = false;
      # "UrlKeyedAnonymizedDataCollectionEnabled" = false;
      "UrlKeyedMetricsAllowed" = false;
      "UserAgentReduction" = 2;
      "UserFeedbackAllowed" = false;
      "WebRtcIPHandling" = "disable_non_proxied_udp";
      "WebRtcTextLogCollectionAllowed" = false;
      # "WebUsbAskForUrls" = [ ] # whitelist of sites allowed to ask for webusb
    };
  };

  # needed for electron apps that won't run on wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # programs.firefox = {
  #   enable = true;
  #   languagePacks = [
  #     "en-US"
  #   ];

  #   # ---- POLICIES ----
  #   # Check about:policies#documentation for options.
  #   policies = {
  #     DisableTelemetry = true;
  #     DisableFirefoxStudies = true;
  #     EnableTrackingProtection = {
  #       Value = true;
  #       Locked = true;
  #       Cryptomining = true;
  #       Fingerprinting = true;
  #     };
  #     DisablePocket = true;
  #     DisableFirefoxAccounts = true;
  #     DisableAccounts = true;
  #     DisableFirefoxScreenshots = true;
  #     OverrideFirstRunPage = "";
  #     OverridePostUpdatePage = "";
  #     DontCheckDefaultBrowser = true;
  #     DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
  #     DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
  #     SearchBar = "unified"; # alternative: "separate"

  #     OfferToSaveLogins = false;
  #     PasswordManagerEnabled = false;

  #     # ---- EXTENSIONS ----
  #     # Check about:support for extension/add-on ID strings.
  #     # Valid strings for installation_mode are "allowed", "blocked",
  #     # "force_installed" and "normal_installed".
  #     ExtensionSettings = {
  #       "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
  #       "uBlock0@raymondhill.net" = {
  #         install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
  #         installation_mode = "force_installed";
  #       };
  #       "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
  #         install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
  #         installation_mode = "force_installed";
  #       };
  #     };
  #   };
  # };

  users.users.asa.packages = [
    pkgs.customPackages.alacritty-wrapped
    pkgs.customPackages.helix-wrapped
    pkgs.customPackages.chromium-wrapped

    # aerc
    # yazi
    # wget

    # fzf
    # ripgrep

    # utilities
    # zip
    # unzip
    # zathura
    # btop
  ]
  ++ webapps;

}
