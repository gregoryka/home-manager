{ pkgs, inputs, ... }:

{

  imports = [
    inputs.declarative-cachix.homeManagerModules.declarative-cachix
    {
      caches.cachix = [
        {
          name = "nix-community";
          sha256 = "0m6kb0a0m3pr6bbzqz54x37h5ri121sraj1idfmsrr6prknc7q3x";
        }
      ];
    }
  ];

  home = {
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    username = "gregorykanter";
    homeDirectory = "/home/gregorykanter";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "23.11"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    packages = with pkgs; [
      # # Adds the 'hello' command to your environment. It prints a friendly
      # # "Hello, world!" when run.
      # pkgs.hello
      cachix
      nixd
      git-credential-manager
      dust
      tldr
      nh
      nix-output-monitor
      nvd
      pyload-ng

      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
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

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    bat.enable = true;
    eza.enable = true;
    btop.enable = true;
    atuin.enable = true;

    git = {
      enable = true;
      lfs.enable = true;
      userEmail = "gregorykanter1@gmail.com";
      userName = "Gregory Kanter";
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        credential = {
          helper = "git-credential-manager";
          credentialStore = "secretservice";
        };
      };
    };

    zsh = {
      enable = true;
      enableCompletion = true;

      # Some plugins use compdef command directly, so run compinit early
      initExtraFirst = "autoload -U compinit && compinit";
      # And then run compinit again to load all completions
      completionInit = "compinit";

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
  };

  xdg = {
    enable = true;
    mime.enable = true;
    systemDirs = {
      config = [ "/etc/xdg" ];
      data = [
        "/usr/share"
        "/usr/local/share"
      ];
    };
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
  targets.genericLinux.enable = true;

  nix = {
    package = with pkgs; nixUnstable;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
