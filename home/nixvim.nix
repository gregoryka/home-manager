{ flake, pkgs, ... }:
{
  imports = [ flake.inputs.nixvim.homeManagerModules.nixvim ];
  # Recommended Nix settings

  programs.nixvim = {
    enable = true;
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
    opts = {
      relativenumber = true; # Relative line numbers
      number = true; # Display the absolute line number of the current line
      undofile = true; # Automatically save and restore undo history
      incsearch = true; # Incremental search: show match for partly typed search command
      ignorecase = true; # When the search query is lower-case, match both lower and upper-case
      smartcase = true; # Override the 'ignorecase' option if the search pattern contains upper
      signcolumn = "yes"; # Whether to show the signcolumn
      colorcolumn = "100"; # Columns to highlight
      fileencoding = "utf-8";
      # File-content encoding for the current buffer
      tabstop = 2; # Number of spaces a <Tab> in the text stands for (local to buffer)
      shiftwidth = 2; # Number of spaces used for each step of (auto)indent (local to buffer)
      expandtab = true; # Expand <Tab> to spaces in Insert mode (local to buffer)
      autoindent = true; # Do clever autoindenting

    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>LazyGit<CR>";
        options = {
          desc = "LazyGit (root dir)";
        };
      }
    ];

    plugins = {
      lazygit.enable = true;
      telescope = {
        enable = true;
        extensions.fzf-native.enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>b" = "buffers";
          "<leader>fh" = "help_tags";
          "<leader>gf" = "git_files";
          "<leader>of" = "oldfiles";
          "<leader>fg" = "live_grep";
          "<leader>fd" = "diagnostics";
        };
      };
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
      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
        };
      };
      web-devicons.enable = true;
    };

  };

}
