{
  writers,
  mkWrapper,
  theme,
  alacritty,
}:
let
  cfg = writers.writeTOML "alacritty.toml" {
    font = {
      normal = {
        family = "JetBrains Mono";
        style = "regular";
      };
      size = 10;
    };

    colors = with theme.colors; {
      primary = {
        foreground = "#${fg-regular}";
        background = "#${bg-regular}";
        dim_foreground = "#${fg-dim}";
        bright_foreground = "#${fg-regular}";
      };

      normal = {
        black = "#${black}";
        red = "#${red}";
        green = "#${green}";
        yellow = "#${yellow}";
        blue = "#${blue}";
        magenta = "#${purple}";
        cyan = "#${cyan}";
        white = "#${white}";
      };

      bright = {
        black = "#5c6370";
        red = "#e06c75";
        green = "#98c379";
        yellow = "#d19a66";
        blue = "#61afef";
        magenta = "#c678dd";
        cyan = "#56b6c2";
        white = "#ffffff";
      };
    };
  };
in
mkWrapper {
  pkg = alacritty;
  alacritty.prependFlags = [
    "--config-file=${cfg}"
  ];
}
