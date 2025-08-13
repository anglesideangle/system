{
  pkgs,
  mkWrapper,
  theme,
  mako,
}:
let
  cfg = pkgs.writeText "config.ini" ''
    font=sans-serif medium ${theme.lengths.font-md}px
    padding=${theme.lengths.padding}
    background-color=#${theme.colors.bg-darker}
    text-color=#${theme.colors.fg-regular}
    border-size=${theme.lengths.border-width}
    border-radius=${theme.lengths.border-radius}
    border-color=#${theme.colors.purple}
    default-timeout=5000
    max-icon-size=32
  '';
in
mkWrapper {
  pkg = mako;
  mako.prependFlags = [
    "--config"
    "${cfg}"
  ];
}
