{
  description = "A home-manager template providing useful tools & settings for Nix-based development";

  inputs = {
    # Principle inputs (updated by `nix run .#update`)
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";
    systems.url = "github:nix-systems/default";

    # Software inputs
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    declarative-cachix.url = "github:jonascarpay/declarative-cachix";
    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };
    devenv.url = "github:cachix/devenv";
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [
        inputs.nixos-flake.flakeModule
        inputs.devenv.flakeModule
        ./nix/toplevel.nix
      ];

      flake.nix-dev-home.username = "gregorykanter";

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        formatter = with pkgs; nixfmt;

        devenv.shells.default = {
          devenv.root =
            let
              devenvRootFileContent = builtins.readFile inputs.devenv-root.outPath;
            in
            pkgs.lib.mkIf (devenvRootFileContent != "") devenvRootFileContent;

          name = "my-project";




          languages.nix = {
            enable = true;
            lsp.package = with pkgs; nixd;
          };

          imports = [
            # This is just like the imports in devenv.nix.
            # See https://devenv.sh/guides/using-with-flake-parts/#import-a-devenv-module
            # ./devenv-foo.nix
          ];

          # https://devenv.sh/reference/options/
          packages = let
          extensions = inputs.nix-vscode-extensions.extensions.${system};
          vscode-ext = pkgs.vscode-with-extensions.override {
            vscode = pkgs.vscodium;
            vscodeExtensions = [
              # extensions.vscode-marketplace.golang.go
              extensions.open-vsx.jnoortheen.nix-ide
            ];
          };
          in
          [
            config.packages.default
            vscode-ext
          ];
        };
      };
    };
}
