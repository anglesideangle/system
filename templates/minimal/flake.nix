{
  description = "Minimal Flake Template";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgs = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      packages = forAllSystems (system: {
        default = pkgs.${system}.hello;
      });

      devShells = forAllSystems (system: {
        default = pkgs.${system}.mkShellNoCC {
          inputsFrom = builtins.attrValuesself.packages.${system};
          packages = [ self.formatter.${system} ];
        };
      });

      formatter = forAllSystems (
        system:
        pkgs.${system}.treefmt.withConfig {
          name = "project-format";

          runtimeInputs = with pkgs.${system}; [
            nixfmt
          ];

          settings = {
            formatter.nix = {
              command = "nixfmt";
              includes = [ "*.nix" ];
            };
          };
        }
      );
    };
}
