{ config, pkgs, lib, ... }:

let
  name = "mi-skam";
  user = "plumps";
  email = "40042054+mi-skam@users.noreply.github.com";
  home =  if pkgs.stdenv.isDarwin then /Users/${user}
          else /home/${user};

in {
  home = {
    username = user;
    homeDirectory = lib.mkDefault home;

    packages = with pkgs; [ nixfmt-classic htop btop ];
    
    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "24.05";
  }; 

  programs = {
    home-manager.enable = true;

    # Shared shell configuration
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    gh.enable = true;

    starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        palette = "catppuccin_mocha";
        add_newline = false;
        format = "$directory$character";
        right_format = "$all";
        command_timeout = 1000;
        git_branch = { format = "[$symbol$branch(:$remote_branch)]($style)"; };
        golang = { format = "[ ](bold cyan)"; };
        palettes.catppuccin_mocha = {
          rosewater = "#f5e0dc";
          flamingo = "#f2cdcd";
          pink = "#f5c2e7";
          mauve = "#cba6f7";
          red = "#f38ba8";
          maroon = "#eba0ac";
          peach = "#fab387";
          yellow = "#f9e2af";
          green = "#a6e3a1";
          teal = "#94e2d5";
          sky = "#89dceb";
          sapphire = "#74c7ec";
          blue = "#89b4fa";
          lavender = "#b4befe";
          text = "#cdd6f4";
          subtext1 = "#bac2de";
          subtext0 = "#a6adc8";
          overlay2 = "#9399b2";
          overlay1 = "#7f849c";
          overlay0 = "#6c7086";
          surface2 = "#585b70";
          surface1 = "#45475a";
          surface0 = "#313244";
          base = "#1e1e2e";
          mantle = "#181825";
          crust = "#11111b";
        };
      };
    };

    zellij = {
      enable = true;
      enableFishIntegration = true;
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    fish = {
      enable = true;
      shellAliases = {
        ".." = "cd ..";
        "..." = "cd ../..";
        "lg" = "lazygit";
        "l" = "eza";
        "ls" = "ls";
        "ll" = "eza -l";
        "rf" = "rm -rf";
        "tree" = "eza --tree";
        "v" = "nvim";
        "vimdiff" = "nvim -d";
      };
      shellAbbrs = { };
      shellInit = ''
        set -g fish_escape_delay_ms 300 # hack to make esc-dot possible in fish
        set -g fish_greeting # remove hello fish text 
      '';
      interactiveShellInit = ''
        set -x PATH /usr/local/bin $PATH
        set -x PATH $HOME/.local/bin $PATH
        set -x PATH $HOME/.deno/bin $PATH
        set -x PATH $HOME/go/bin $PATH

        zellij attach -b -c default 2>/dev/null # background start

        if test -z "$SSH_ENV"
            set -xg SSH_ENV $HOME/.ssh/environment
        end

        if not __ssh_agent_is_started
            __ssh_agent_start
        end
      '';
      functions = {
        __ssh_agent_is_started = ''
          	      if test -n "$SSH_CONNECTION"
          		      # This is an SSH session
          		      ssh-add -l > /dev/null 2>&1
          		      if test $status -eq 0 -o $status -eq 1
          			      # An SSH agent was forwarded
          			      return 0
          		      end
          	      end

                  if begin; test -f "$SSH_ENV"; and test -z "$SSH_AGENT_PID"; end
                    source $SSH_ENV > /dev/null
                  end

                  if test -z "$SSH_AGENT_PID"
                    return 1
                  end

                  ssh-add -l > /dev/null 2>&1
                  if test $status -eq 2
                    return 1
                  end
        '';
        __ssh_agent_start = ''
          ssh-agent -c | sed 's/^echo/#echo/' >$SSH_ENV
          chmod 600 $SSH_ENV
          source $SSH_ENV >/dev/null
        '';
      };
    };

    git = {
      enable = true;
      ignores = [ "*.swp" ];
      userName = name;
      userEmail = email;
      lfs = { enable = true; };
      extraConfig = {
        init.defaultBranch = "main";
        core = {
          editor = "vim";
          autocrlf = "input";
        };
        pull.rebase = true;
        rebase.autoStash = true;
      };
    };

    neovim.enable = true;

    ssh = {
      enable = true;
      includes = map (path: "${(builtins.toString home)}/${path}") [
        ".ssh/config"
        ".ssh/pme/config"
        ".ssh/tadda/config"
      ];
    };
  };
}
