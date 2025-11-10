{
  lib,
  mkWrapper,
  chromium,
}:
let
  enable_features = [
    "CapReferrerToOriginOnCrossOrigin"
    "ContentSettingsPartitioning"
    "HstsTopLevelNavigationsOnly"
    "LocalNetworkAccessChecks:LocalNetworkAccessChecksWarn/false"
    "LocalNetworkAccessChecksWebRTC"
    "PartitionConnectionsByNetworkIsolationKey"
    "ReduceAcceptLanguage"
    "SplitCodeCacheByNetworkIsolationKey"
    "SplitCacheByNetworkIsolationKey"
    "SplitCacheByIncludeCredentials"
    "SplitCacheByNavigationInitiator"
    "StrictOriginIsolation"

    # https://wiki.archlinux.org/title/Chromium
    "TouchpadOverscrollHistoryNavigation"
    "WaylandPerSurfaceScale"
    "WaylandUiScale"
  ];
  disable_features = [
    "AllowSwiftShaderFallback"
    "AllowSoftwareGLFallbackDueToCrash"
    "AutofillServerCommunication"
    "BrowsingTopics"
    "BrowsingTopicsDocumentAPI"
    "BrowsingTopicsParameters"
    "InterestFeedV2"
    "NTPPopularSitesBakedInContent"
    "UsePopularSitesSuggestions"
    "LensStandalone"
    "MediaDrmPreprovisioning"

    "OptimizationHints"
    "OptimizationHintsFetching"
    "OptimizationHintsFetching"
    "AnonymousDataConsent"
    "OptimizationPersonalizedHintsFetching"
    "OptimizationGuideModelDownloading"
    "TextSafetyClassifier"

    "PrivacySandboxSettings4"
    "Reporting"
    "CrashReporting"
    "DocumentReporting"
    "TabHoverCardImages"

    # "WebGPUBlobCache"
    # "WebGPUService"
  ];
in
mkWrapper {
  pkg = chromium;
  chromium.prependFlags = [
    "--component-updater=--disable-pings"
    "--disable-breakpad --disable-crash-reporter"
    "--extension-content-verification=enforce_strict --extensions-install-verification=enforce_strict"
    # "--js-flags=--jitless"
    "--no-pings"
    "--ozone-platform=wayland"
    "--enable-features=${lib.strings.concatStringsSep "," enable_features}"
    "--disable-features=${lib.strings.concatStringsSep "," disable_features}"

    # more arch wiki
    "--gtk-version=4"
  ];
}
