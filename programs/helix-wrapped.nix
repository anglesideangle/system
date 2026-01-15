{
  lib,
  writers,
  mkWrapper,
  helix,
  nushell,
  lazygit,
  delta,
}:
let
  cfg = writers.writeTOML "config.toml" {
    theme = "rose_pine";

    editor = {
      shell = [
        "${lib.getExe' nushell "nu"}"
        "-c"
      ];

      idle-timeout = 5;
      completion-timeout = 5;
      completion-trigger-len = 1;
      completion-replace = true;

      true-color = true;

      bufferline = "multiple";

      color-modes = true;

      trim-final-newlines = true;
      trim-trailing-whitespace = true;

      # popup-border = "popup";

      indent-heuristic = "tree-sitter"; # TODO?

      end-of-line-diagnostics = "hint";
      inline-diagnostics.cursor-line = "warning";

      # lsp.display-inlay-hints = true;

      cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };

      soft-wrap = {
        enable = false;
        # wrap-at-text-width = true;
      };
    };

    # full smart tab functionality for terminals that support the extended
    # keyboard protocol
    keys = {
      normal = {
        tab = "move_parent_node_end";
        S-tab = "move_parent_node_start";

        # lazygit
        C-g = [
          ":write-all"
          ":insert-output ^${lib.getExe lazygit} | ignore"
          ":redraw"
          ":reload-all"
          ":set mouse false"
          ":set mouse true"
        ];

        # quickly switch between buffers
        A-h = "goto_previous_buffer";
        A-l = "goto_next_buffer";
      };

      insert.S-tab = "move_parent_node_start";

      select = {
        tab = "extend_parent_node_end";
        S-tab = "extend_parent_node_start";
      };

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
