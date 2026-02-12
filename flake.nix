{
  description = "Asa's personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware/master";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      hardware,
      lanzaboote,
      nixpak,
      ...
    }@inputs:
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
        }
      );
    in
    {
      nixosConfigurations.asa-fw = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          modules/system.nix
          modules/desktop.nix
          modules/apps.nix
          modules/fonts.nix
          modules/networking.nix
          modules/audio.nix
          modules/dev.nix
          hardware/fw-13.nix
          hardware.nixosModules.framework-13-7040-amd
          lanzaboote.nixosModules.lanzaboote
          {
            nixpkgs.overlays = [
              (final: prev: {
                customPackages = import ./programs {
                  pkgs = prev;
                };
              })
            ];
          }
        ];
      };

      packages = forAllSystems (system: import ./programs { pkgs = pkgsFor.${system}; });

      devShells = forAllSystems (system: {
        default = pkgsFor.${system}.mkShellNoCC {
          packages = [
            pkgsFor.${system}.nixd
            self.formatter.${system}
          ];
        };
      });

      formatter = forAllSystems (system: pkgsFor.${system}.nixfmt-tree);

      templates = import ./templates;
    };
}
