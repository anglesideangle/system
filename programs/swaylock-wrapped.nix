{
  pkgs,
  mkWrapper,
  theme,
  swaylock,
}:
let
  cfg = pkgs.writeText "config.ini" ''
    scaling=fill
    font="Inter Display"
    font-size=30
    indicator-radius=64px
    indicator-thickness=6px

    color=${theme.colors.bg-darker}
    text-color=${theme.colors.fg-regular}
    text-clear-color=${theme.colors.fg-regular}
    text-wrong-color=${theme.colors.fg-regular}
    text-ver-color=${theme.colors.fg-regular}
    text-caps-lock-color=${theme.colors.fg-regular}

    bs-hl-color=${theme.colors.red}
    caps-lock-bs-hl-color=${theme.colors.red}
    key-hl-color=${theme.colors.blue}
    caps-lock-key-hl-color=${theme.colors.blue}

    separator-color=${theme.colors.bg-darker}

    layout-bg-color=${theme.colors.bg-darker}
    layout-border-color=${theme.colors.bg-darker}
    layout-text-color=${theme.colors.fg-regular}

    inside-color=${theme.colors.bg-darker}
    inside-clear-color=${theme.colors.bg-darker}
    inside-caps-lock-color=${theme.colors.bg-darker}
    inside-ver-color=${theme.colors.bg-darker}
    inside-wrong-color=${theme.colors.bg-darker}

    ring-color=${theme.colors.bg-darker}
    ring-clear-color=${theme.colors.yellow}
    ring-caps-lock-color=${theme.colors.purple}
    ring-ver-color=${theme.colors.blue}
    ring-wrong-color=${theme.colors.red}

    line-uses-inside
  '';
in
mkWrapper {
  pkg = swaylock;
  swaylock.prependFlags = [
    "--config"
    "${cfg}"
  ];
}
