{
  sources ? import ../npins,
  pkgs ? import sources.nixpkgs { },
}:
let
  allFiles = builtins.attrNames (builtins.readDir ./.);
  packageFiles = builtins.filter (
    file: pkgs.lib.hasSuffix ".nix" file && file != "default.nix"
  ) allFiles;
in
pkgs.lib.makeScope pkgs.newScope (
  self:
  {
    mkWrapper = import ../utils/wrap.nix pkgs;
    theme = import ../config/theme.nix;
  }
  // builtins.listToAttrs (
    map (file: {
      name = pkgs.lib.removeSuffix ".nix" file;
      value = self.callPackage ./${file} { };
    }) packageFiles
  )
)
