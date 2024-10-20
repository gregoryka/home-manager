{ flake, pkgs, ... }:
{
  imports = [ flake.inputs.nixvim.homeManagerModules.nixvim ];
  # Recommended Nix settings

  programs.nixvim = {
    enable = true;

    plugins = {
      treesitter = {
        enable = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          c
          cmake
          comment
          cpp
          cuda
          diff
          gitcommit
          gitignore
          json
          meson
          nix
          python
          tmux
          xml
          yaml
        ];

        folding = true;
        nixGrammars = true; # Install via nix
        gccPackage = null;
        nodejsPackage = null;
        treesitterPackage = null;

        settings = {
          auto_install = false;
          highlight.enable = true;
          incremental_selection.enable = true;
          indent.enable = true;
        };
      };
    };

  };

}
