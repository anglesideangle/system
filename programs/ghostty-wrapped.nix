{
  pkgs,
  mkWrapper,
  theme,
  ghostty,
}:
let
  cfg = pkgs.writeText "config" ''
    # font-family = "Hack"
    font-size = ${theme.lengths.font-sm}

    theme = "OneHalfDark"

    window-padding-x = 8
    window-padding-y = 8
    window-padding-balance = false
    window-padding-color = extend

    window-decoration = none
    window-theme = auto

    confirm-close-surface = false

    shell-integration = detect
    shell-integration-features = true

    gtk-single-instance = true
    quit-after-last-window-closed = false
  '';
in
mkWrapper {
  pkg = ghostty;
  ghostty.prependFlags = [
    "--config-file=${cfg}"
  ];
}
