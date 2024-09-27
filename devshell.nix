{ inputs, ... }:

{
  imports = [
    inputs.devshell.flakeModule
  ];
  perSystem =
    {
      pkgs,
      system,
      ...
    }:
    {
      devshells.default = {
        packages =
          let
            extensions = inputs.nix-vscode-extensions.extensions.${system};
            vscode-ext = pkgs.vscode-with-extensions.override {
              vscode = pkgs.vscodium;
              vscodeExtensions = [
                extensions.open-vsx.jnoortheen.nix-ide
                extensions.open-vsx.eamodio.gitlens
              ];
            };
          in
          [
            vscode-ext
          ];
      };
    };
}
