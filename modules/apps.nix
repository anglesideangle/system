{
  pkgs,
  ...
}:
{
  services.flatpak.enable = true;

  # systemd.user.services.alacritty = {
  #   description = "Alacritty Daemon";
  #   wantedBy = [ "graphical.target" ];
  #   serviceConfig = {
  #     ExecStart = "${lib.getExe pkgs.alacritty} --daemon";
  #     Restart = "on-failure";
  #   };
  # };

  programs.chromium = {
    enable = true;

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
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = [
    pkgs.helix
  ];
}
