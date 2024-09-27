{
  flake,
  pkgs,
  config,
  ...
}:

{
  home.packages = with pkgs; [
    nix-zsh-completions # completion for classic commands; completion for new nix is built in the nix package
  ];

  programs = {
    zsh = {
      enable = true;
      # enableCompletion adds nix-zsh-completion package and calls compinit.
      # I added the package manually and a plugin will call compinit.
      enableCompletion = false;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      zprof.enable = true;

      # initExtraFirst =
      #   "zstyle ':zephyr:plugin:completion' manual on"; # Set zephyr manual completion flag

      dotDir =
        let
          relativeConfigHome =
            builtins.replaceStrings
              [
                config.home.homeDirectory
                "/.config"
              ]
              [
                ""
                ".config"
              ]
              config.xdg.configHome;
        in
        "${relativeConfigHome}/zsh";

      antidote = {
        enable = true;
        plugins = [
          # zephyr completion takes care of the problem where some plugins use compdef directly
          # But slows down init shell considerably for no real benefit (compinit is slow)
          # "${flake.inputs.zephyr.outPath} path:plugins/completion"

          "${flake.inputs.zsh-completions.outPath} path:src kind:fpath"

          # Saner key bindings
          "${flake.inputs.zephyr.outPath} path:plugins/editor"

          "${flake.inputs.zsh-bench.outPath} kind:path"

          # For fedora based systems
          "${flake.inputs.ohmyzsh.outPath} path:plugins/dnf"

          # Flatpak completion plugin which in not in fpath style - defer to get around
          "${flake.inputs.flatpak-zsh-completion.outPath} kind:defer"

          # Enable actual completion
          "${flake.inputs.zsh-utils.outPath} path:completion"

          # Supposedly this should be at the end
          # https://github.com/getantidote/zdotdir/blob/1a34e6dd3d78862c82ba3babd19bd8c882c77d65/.zsh_plugins.txt#L227
          # autosuggestion.enable takes care of this one already
          # "zsh-users/zsh-autosuggestions"
        ];
        useFriendlyNames = true;
      };
    };

    # Starship prompt for zsh configuration
    starship = {
      enable = true;
      settings = {
        username = {
          style_user = "blue bold";
          style_root = "red bold";
          format = "[$user]($style) ";
          disabled = false;
          show_always = true;
        };
        hostname = {
          ssh_only = false;
          ssh_symbol = "🌐 ";
          format = "on [$hostname](bold red) ";
          trim_at = ".local";
          disabled = false;
        };
      };
    };
  };
}
