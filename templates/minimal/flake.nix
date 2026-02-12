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
      pkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      packages = forAllSystems (system: {
        default = pkgsFor.${system}.hello;
      });

      devShells = forAllSystems (system: {
        default = pkgsFor.${system}.mkShellNoCC {
          inputsFrom = builtins.attrValues self.packages.${system} ++ [ self.formatter.${system} ];
          packages = [ self.formatter.${system} ];
        };
      });

      formatter = forAllSystems (
        system:
        pkgsFor.${system}.treefmt.withConfig {
          name = "project-format";

          runtimeInputs = with pkgsFor.${system}; [
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
