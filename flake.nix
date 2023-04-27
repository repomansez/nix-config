{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hardware.url = "github:nixos/nixos-hardware";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
    # Hyprland shit
    hyprland.url = "github:hyprwm/Hyprland";
    hyprwm-contrib.url = "github:hyprwm/contrib";
    # Anyrun shit
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    home-manager,
    hyprland,
    hyprwm-contrib,
    anyrun,
    ...
  } @ inputs: {
    # formatter ig
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;}; # Pass flake inputs to our config
        # > Our main nixos configuration file <
        modules = [./nixos/configuration.nix];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      # eplace with your username@hostname
      "nigerius@nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs hyprland hyprwm-contrib anyrun;}; # Pass flake inputs to our config
        # > Our main home-manager configuration file <
        modules = [
          ./home-manager/home.nix
          #hyprland.homeManagerModules.default
        ];
      };
    };
  };
}
