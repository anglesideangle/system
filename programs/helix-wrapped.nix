{
  writers,
  mkWrapper,
  helix,
}:
let
  cfg = writers.writeTOML "config.toml" {
      theme = "zed_onedark";

      keys.normal = {
        tab = "goto_next_buffer";
        S-tab = "goto_previous_buffer";
      };

      editor = {
        bufferline = "multiple";
        idle-timeout = 5;
        completion-timeout = 5;
        end-of-line-diagnostics = "hint";
        inline-diagnostics.cursor-line = "error";

        lsp.display-inlay-hints = true;

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        file-picker = {
          hidden = true;
          ignore = true;
        };

        soft-wrap.enable = true;
      };
    };
in
mkWrapper {
  pkg = helix;
  hx.prependFlags = [
    "--config"
    "${cfg}"
  ];
}
