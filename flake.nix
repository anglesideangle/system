{
  description = "Asa's personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hardware.url = "github:nixos/nixos-hardware/master";
  };

  outputs =
    {
      nixpkgs,
      hardware,
      ...
    }@inputs:
    let
      forAllSystems =
        function:
        nixpkgs.lib.genAttrs [
          "x86_64-linux" # <- useful
          "aarch64-linux" # <- aspirational
          # "risc64-linux" # <- aspirational
          "aarch64-darwin" # <- useless
        ] (system: function nixpkgs.legacyPackages.${system});
    in
    rec {
      nixosConfigurations.asa-fw = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          packages = packages."x86_64-linux";
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
        ];
      };

      packages = forAllSystems (pkgs: import ./programs { inherit pkgs; });

      devShells = forAllSystems (pkgs: pkgs.nil);

      formatter = forAllSystems (pkgs: pkgs.nixfmt-tree);
    };
}
