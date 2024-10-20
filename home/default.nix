{ pkgs, config, ... }:
{
  imports = [
    ./nix.nix
    ./nix-index.nix
    ./nixvim.nix
    ./zsh.nix
  ];

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
      tmux

      # Nix dev
      cachix
      nixd # Nix language server
      nix-info
      nixci
      nix-health

      dust
      tldr
      nh
      nix-output-monitor
      nvd

      # nix-du allows
      nix-du
      zgrviewer

      pyload-ng
      megasync

      # For eza
      cascadia-code
      font-awesome_6
      (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
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

    # Better `cat`
    bat.enable = true;
    eza = {
      enable = true;
      icons = "auto";
    };
    btop.enable = true;
    atuin.enable = true;
    # Type `z <pat>` to cd to some directory
    zoxide.enable = true;
    # Type `<ctrl> + r` to fuzzy search your shell history
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    man = {
      enable = true;
      generateCaches = true;
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
      ignores = [
        "*~"
        "*.swp"
      ];
      lfs.enable = true;
      userEmail = "gregorykanter1@gmail.com";
      userName = "Gregory Kanter";
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
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
}
