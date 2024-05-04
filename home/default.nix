{ pkgs, config, ... }: {
  imports = [ ./nix.nix ./nix-index.nix ];

  # Nix packages to install to $HOME
  #
  # Search for packages here: https://search.nixos.org/packages
  home = {
    packages = with pkgs; [
      # Unix tools
      ripgrep # Better `grep`
      fd
      sd
      tree

      # Nix dev
      cachix
      nixd # Nix language server
      nix-info
      nixpkgs-fmt
      nixci
      nix-health

      # Dev
      tmate

      dust
      tldr
      nh
      nix-output-monitor
      nvd
      pyload-ng
      devenv
    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };

    shellAliases = { };

    # Home Manager can also manage your environment variables through
    # 'home.sessionVariables'. These will be explicitly sourced when using a
    # shell provided by Home Manager. If you don't want to manage your shell
    # through Home Manager then you have to manually source 'hm-session-vars.sh'
    # located at either
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/gregorykanter/etc/profile.d/hm-session-vars.sh
    #
    sessionVariables = {
      # EDITOR = "emacs";
    };
  };

  # Programs natively supported by home-manager.
  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      envExtra = ''
        # Make Nix and home-manager installed things available in PATH.
        export PATH=/run/current-system/sw/bin/:/nix/var/nix/profiles/default/bin:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:$PATH
      '';

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
          "ohmyzsh/ohmyzsh path:lib" # Prereq for some oh-my-zsh plugins and themes
          "ohmyzsh/ohmyzsh path:themes/robbyrussell.zsh-theme"

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

    # Better `cat`
    bat.enable = true;
    eza.enable = true;
    btop.enable = true;
    atuin.enable = true;
    # Type `z <pat>` to cd to some directory
    zoxide.enable = true;
    # Type `<ctrl> + r` to fuzzy search your shell history
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

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

    # https://nixos.asia/en/direnv
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # https://nixos.asia/en/git
    git = {
      enable = true;
      # userName = "John Doe";
      # userEmail = "johndoe@example.com";
      ignores = [ "*~" "*.swp" ];
      lfs.enable = true;
      userEmail = "gregorykanter1@gmail.com";
      userName = "Gregory Kanter";
      extraConfig = {
        init = { defaultBranch = "main"; };
        credential = {
          helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
          credentialStore = "secretservice";
        };
      };
    };
    lazygit.enable = true;

  };
  xdg = {
    enable = true;
    mime.enable = true;
    systemDirs = {
      config = [ "/etc/xdg" ];
      data = [ "/usr/share" "/usr/local/share" ];
    };
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
  targets.genericLinux.enable = true;
}
