{ pkgs }:
pkgs.lib.fix (
  self:
  let
    callPackage = pkgs.lib.callPackageWith (
      pkgs
      // self
      // {
        mkWrapper = import ../utils/wrap.nix pkgs;
        theme = import ../config/theme.nix;
      }
    );
    allFiles = builtins.attrNames (builtins.readDir ./.);
    packageFiles = builtins.filter (
      file: pkgs.lib.hasSuffix ".nix" file && file != "default.nix"
    ) allFiles;
  in
  builtins.listToAttrs (
    map (file: {
      name = pkgs.lib.removeSuffix ".nix" file;
      value = callPackage ./${file} { };
    }) packageFiles
  )
)
