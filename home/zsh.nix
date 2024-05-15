{config, ...}:

{
  # TODO - fixup completion to occur in antidote via plugin instead.
  programs = {
      zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      # Some plugins use compdef command directly, so run compinit early
      initExtraFirst = "autoload -U compinit && compinit";
      # And then run compinit again to load all completions
      completionInit = "compinit";

      dotDir = let
        relativeConfigHome =
          builtins.replaceStrings [ config.home.homeDirectory "/.config" ] [
            ""
            ".config"
          ] config.xdg.configHome;
      in "${relativeConfigHome}/zsh";

      antidote = {
        enable = true;
        plugins = [
          # Completion files are marked with kind:fpath
          "zsh-users/zsh-completions path:src kind:fpath"

          # For fedora based systems
          "ohmyzsh/ohmyzsh path:plugins/dnf"
          "bilelmoussaoui/flatpak-zsh-completion"
          # Supposedly this should be at the end
          # https://github.com/getantidote/zdotdir/blob/1a34e6dd3d78862c82ba3babd19bd8c882c77d65/.zsh_plugins.txt#L227
          "zsh-users/zsh-autosuggestions"
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