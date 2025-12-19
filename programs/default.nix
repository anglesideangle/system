{ pkgs }:
pkgs.lib.makeScope pkgs.newScope (
  self:
  {
    mkWrapper = import ../utils/wrap.nix pkgs;
    theme = import ../config/theme.nix;
  }
  // pkgs.lib.packagesFromDirectoryRecursive {
    inherit (self) callPackage;
    directory = ./.;
  }
)
