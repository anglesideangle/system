{
  pkgs,
  lib,
  mkWrapper,
  theme,
  fuzzel,
  alacritty-wrapped,
}:
let
  cfg = pkgs.writeText "config.ini" ''
    font=sans-serif:size=${theme.lengths.font-lg}
    use-bold=true
    dpi-aware=auto
    placeholder="system search..."
    prompt=""
    terminal="${lib.getExe alacritty-wrapped} -e"

    lines=12
    width=24

    horizontal-pad=16
    vertical-pad=${theme.lengths.padding}
    inner-pad=${theme.lengths.padding}

    [colors]
    background=${theme.colors.bg-darker}FF
    text=${theme.colors.fg-dim}FF
    prompt=${theme.colors.fg-dim}FF
    placeholder=${theme.colors.fg-dim}FF
    input=${theme.colors.fg-regular}FF
    match=${theme.colors.fg-regular}FF
    selection=${theme.colors.bg-regular}FF
    selection-text=${theme.colors.fg-regular}FF
    selection-match=${theme.colors.fg-regular}FF
    border=${theme.colors.cyan}FF

    [border]
    width=${theme.lengths.border-width}
    radius=${theme.lengths.border-radius}
  '';
in
mkWrapper {
  pkg = fuzzel;
  fuzzel.prependFlags = [
    "--config"
    "${cfg}"
  ];
}
