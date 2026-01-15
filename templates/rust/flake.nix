{
  description = "Nix Rust Project Template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    crate2nix.url = "github:nix-community/crate2nix";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs =
    {
      self,
      nixpkgs,
      crate2nix,
      rust-overlay,
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgsFor = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          overlays = [ rust-overlay.overlays.default ];
        }
      );
      rustToolchainFor = forAllSystems (
        system: pkgsFor.${system}.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml
      );
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = pkgsFor.${system};
          toolchain = rustToolchainFor.${system};

          crate2nixTools = pkgs.callPackage "${crate2nix}/tools.nix" { };

          workspaceDerivation = crate2nixTools.generatedCargoNix {
            name = "workspace-build";
            src = ./.;
          };

          buildRustCrateForPkgs =
            crate:
            pkgs.buildRustCrate.override {
              rustc = toolchain;
              cargo = toolchain;
            };

          build = pkgs.callPackage workspaceDerivation {
            inherit buildRustCrateForPkgs;
          };
        in
        nixpkgs.lib.mapAttrs (name: crate: crate.build) build.workspaceMembers
        // {
          default = build.rootCrate.build;
        }
      );

      checks = forAllSystems (
        system:
        nixpkgs.lib.mapAttrs (
          name: drv:
          drv.override {
            runTests = true;
          }
        ) self.packages.${system}
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = pkgsFor.${system};
        in
        {
          default = pkgs.mkShell {
            inputsFrom = builtins.attrValues self.packages.${system} ++ [ self.formatter.${system} ];

            packages = [
              rustToolchainFor.${system}

              pkgs.rust-analyzer
              pkgs.nixd

              crate2nix.packages.${system}.default
              self.formatter.${system}
            ];
          };
        }
      );

      formatter = forAllSystems (
        system:
        pkgsFor.${system}.treefmt.withConfig {
          name = "project-format";

          runtimeInputs = with pkgsFor.${system}; [
            nixfmt
            rustToolchainFor.${system}
          ];

          settings = {
            formatter.nix = {
              command = "nixfmt";
              includes = [ "*.nix" ];
            };

            formatter.rust = {
              command = "rustfmt";
              includes = [ "*.rs" ];
            };
          };
        }
      );
    };
}
