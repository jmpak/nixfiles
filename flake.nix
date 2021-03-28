{
  description = "$HOME/.dotfiles";

  inputs = {
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = github:LnL7/nix-darwin/master;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = github:nix-community/home-manager;
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    devshell.url = github:numtide/devshell;
    armada = {
      url = "git+ssh://git@github.com/hireupau/armada?ref=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, home-manager, nixpkgs, darwin, armada, ... }@inputs: {
    darwinConfigurations.b12y = darwin.lib.darwinSystem {
      modules = [
        ./darwin/default.nix
        ./darwin/b12y.nix
        ./home/manager.nix
        home-manager.darwinModule
        { home-manager.users.james = ./home/b12y.nix; }
      ];
    };

    darwinConfigurations.hireup = darwin.lib.darwinSystem {
      modules = [
        ./darwin/default.nix
        ./darwin/hireup.nix
        ./home/manager.nix
        self.hireup.darwinConfiguration
        home-manager.darwinModule
        { nixpkgs.overlays = [ armada.overlay ]; }
        { home-manager.users.jamesottaway = ./home/hireup.nix; }
        { home-manager.users.jamesottaway.imports = [ self.hireup.homeManagerConfiguration ]; }
      ];
    };

    homeManagerConfigurations.b12y = home-manager.lib.homeManagerConfiguration rec {
      configuration = [
        ./home/hireup.nix
        self.hireup.homeManagerConfiguration
      ];
      system = "x86_64-darwin";
      username = "james";
      homeDirectory = "/Users/${username}";
    };

    hireup = {
      homeManagerConfiguration = import ./hireup/home-manager;
      darwinConfiguration = import ./hireup/nix-darwin;
    };

    checks.x86_64-darwin = {
      b12y = self.darwinConfigurations.b12y.system;
      hireup = self.darwinConfigurations.hireup.system;
    };
  };
}
