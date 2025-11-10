{
  description = "Asa's personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware/master";
    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell";
    };
    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      hardware,
      noctalia,
      nixpak,
      ...
    }@inputs:
    let
      noctalia-overlay = system: final: prev: { noctalia-shell = noctalia.packages.${system}.default; };
      forAllSystems =
        function:
        nixpkgs.lib.genAttrs [
          "x86_64-linux" # <- useful
          "aarch64-linux" # <- aspirational
          "aarch64-darwin" # <- useless
        ] (system: function (nixpkgs.legacyPackages.${system}.extend (noctalia-overlay system)));
    in
    {
      nixosConfigurations.asa-fw = nixpkgs.lib.nixosSystem rec {
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
          {
            nixpkgs.overlays = [
              (noctalia-overlay system)
              (final: prev: {
                customPackages = import ./programs {
                  pkgs = prev;
                };
              })
            ];
          }
        ];
      };

      packages = forAllSystems (pkgs: import ./programs { inherit pkgs; });

      devShell = forAllSystems (pkgs: pkgs.nixd);

      formatter = forAllSystems (pkgs: pkgs.nixfmt-tree);
    };
}
