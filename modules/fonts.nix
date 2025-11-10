{
  pkgs,
  ...
}:
{
  fonts.packages = with pkgs; [
    inter
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    noto-fonts-monochrome-emoji
    font-awesome
  ];

  fonts.fontconfig = {
    enable = true;
    # hinting.enable = false;
    # antialias = false;
    # subpixel.lcdfilter = "none";

    defaultFonts = {
      sansSerif = [
        "Inter"
        "Noto Sans"
        "Noto Sans CJK SC"
        "Noto Sans CJK TC"
        "Noto Sans CJK JP"
        "Noto Sans CJK KR"
        "Noto Sans Devanagari"
        "Noto Sans Arabic"
        "Liberation Sans"
        "DejaVu Sans"
      ];

      serif = [
        "Noto Serif"
        "Noto Serif CJK SC"
        "Noto Serif CJK TC"
        "Noto Serif CJK JP"
        "Noto Serif CJK KR"
        "Noto Serif Devanagari"
        "Noto Serif Arabic"
        "Liberation Serif"
        "DejaVu Serif"
      ];

      monospace = [
        "JetBrains Mono"
        "Noto Sans Mono"
        "Noto Sans Mono CJK SC"
        "Noto Sans Mono CJK TC"
        "Noto Sans Mono CJK JP"
        "Noto Sans Mono CJK KR"
        "Liberation Mono"
        "DejaVu Sans Mono"
      ];

      emoji = [
        "Noto Color Emoji"
      ];
    };
  };

  # better font rendering by enabling stem darkening
  # https://blog.aktsbot.in/no-more-blurry-fonts.html
  # https://freetype.org/freetype2/docs/reference/ft2-properties.html#no-stem-darkening
  environment.sessionVariables.FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";
}
