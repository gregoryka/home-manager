{
  description = "A home-manager template providing useful tools & settings for Nix-based development";

  inputs = {
    # Principle inputs (updated by `nix run .#update`)
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-unified.url = "github:srid/nixos-unified";
    systems.url = "github:nix-systems/default";

    # Software inputs
    declarative-cachix.url = "github:jonascarpay/declarative-cachix";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        home-manager.follows = "home-manager";
        nix-darwin.follows = "";
        treefmt-nix.follows = "";
      };
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Zsh stuff
    zephyr = {
      url = "github:mattmc3/zephyr";
      flake = false;
    };
    # Updated zsh-completions compared to nixpkgs
    zsh-completions = {
      url = "github:zsh-users/zsh-completions";
      flake = false;
    };
    ohmyzsh = {
      url = "github:ohmyzsh/ohmyzsh";
      flake = false;
    };
    zsh-utils = {
      url = "github:belak/zsh-utils";
      flake = false;
    };
    flatpak-zsh-completion = {
      url = "github:bilelmoussaoui/flatpak-zsh-completion";
      flake = false;
    };
    zsh-bench = {
      url = "github:romkatv/zsh-bench";
      flake = false;
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      debug = true;
      systems = import inputs.systems;
      imports = [
        inputs.nixos-unified.flakeModules.default
        ./devshell.nix
        ./formatter.nix
        ./nix/toplevel.nix
      ];

      flake.nix-dev-home.username = "gregorykanter";
    };
}
