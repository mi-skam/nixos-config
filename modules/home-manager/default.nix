{ config, pkgs, lib, ... }:

let
  name = "mi-skam";
  user = "plumps";
  email = "40042054+mi-skam@users.noreply.github.com";
  home = if pkgs.stdenv.isDarwin then /Users/${user} else /home/${user};

in {
  home = {
    username = user;
    homeDirectory = lib.mkDefault home;

    packages = with pkgs; [ nixfmt-classic htop btop file ];

    file.zellij = {
      target = ".config/zellij/config.kdl";
      text = ''
          default_mode "locked"
              
          ${if pkgs.stdenv.isDarwin then "copy_command pbcopy" else ""}

          keybinds clear-defaults=true {
            locked {
                bind "Ctrl g" { SwitchToMode "normal"; }
            }
            pane {
                bind "left" { MoveFocus "left"; }
                bind "down" { MoveFocus "down"; }
                bind "up" { MoveFocus "up"; }
                bind "right" { MoveFocus "right"; }
                bind "c" { SwitchToMode "renamepane"; PaneNameInput 0; }
                bind "d" { NewPane "down"; SwitchToMode "locked"; }
                bind "e" { TogglePaneEmbedOrFloating; SwitchToMode "locked"; }
                bind "f" { ToggleFocusFullscreen; SwitchToMode "locked"; }
                bind "n" { MoveFocus "left"; }
                bind "r" { MoveFocus "down"; }
                bind "g" { MoveFocus "up"; }
                bind "t" { MoveFocus "right"; }
                bind "b" { NewPane; SwitchToMode "locked"; }
                bind "p" { SwitchToMode "normal"; }
                bind "B" { NewPane "right"; SwitchToMode "locked"; }
                bind "w" { ToggleFloatingPanes; SwitchToMode "locked"; }
                bind "x" { CloseFocus; SwitchToMode "locked"; }
                bind "z" { TogglePaneFrames; SwitchToMode "locked"; }
                bind "tab" { SwitchFocus; }
            }
            tab {
                bind "left" { GoToPreviousTab; }
                bind "down" { GoToNextTab; }
                bind "up" { GoToPreviousTab; }
                bind "right" { GoToNextTab; }
                bind "1" { GoToTab 1; SwitchToMode "locked"; }
                bind "2" { GoToTab 2; SwitchToMode "locked"; }
                bind "3" { GoToTab 3; SwitchToMode "locked"; }
                bind "4" { GoToTab 4; SwitchToMode "locked"; }
                bind "5" { GoToTab 5; SwitchToMode "locked"; }
                bind "6" { GoToTab 6; SwitchToMode "locked"; }
                bind "7" { GoToTab 7; SwitchToMode "locked"; }
                bind "8" { GoToTab 8; SwitchToMode "locked"; }
                bind "9" { GoToTab 9; SwitchToMode "locked"; }
                bind "[" { BreakPaneLeft; SwitchToMode "locked"; }
                bind "]" { BreakPaneRight; SwitchToMode "locked"; }
                bind "b" { BreakPane; SwitchToMode "locked"; }
                bind "n" { GoToPreviousTab; }
                bind "r" { GoToNextTab; }
                bind "g" { GoToPreviousTab; }
                bind "t" { GoToNextTab; }
                bind "b" { NewTab; SwitchToMode "locked"; }
                bind "r" { SwitchToMode "renametab"; TabNameInput 0; }
                bind "s" { ToggleActiveSyncTab; SwitchToMode "locked"; }
                bind "t" { SwitchToMode "normal"; }
                bind "x" { CloseTab; SwitchToMode "locked"; }
                bind "tab" { ToggleTab; }
            }
            resize {
                bind "left" { Resize "Increase left"; }
                bind "down" { Resize "Increase down"; }
                bind "up" { Resize "Increase up"; }
                bind "right" { Resize "Increase right"; }
                bind "+" { Resize "Increase"; }
                bind "-" { Resize "Decrease"; }
                bind "=" { Resize "Increase"; }
                bind "N" { Resize "Decrease left"; }
                bind "R" { Resize "Decrease down"; }
                bind "G" { Resize "Decrease up"; }
                bind "T" { Resize "Decrease right"; }
                bind "n" { Resize "Increase left"; }
                bind "r" { Resize "Increase down"; }
                bind "g" { Resize "Increase up"; }
                bind "t" { Resize "Increase right"; }
                bind "r" { SwitchToMode "normal"; }
            }
            move {
                bind "left" { MovePane "left"; }
                bind "down" { MovePane "down"; }
                bind "up" { MovePane "up"; }
                bind "right" { MovePane "right"; }
                bind "n" { MovePane "left"; }
                bind "r" { MovePane "down"; }
                bind "g" { MovePane "up"; }
                bind "t" { MovePane "right"; }
                bind "m" { SwitchToMode "normal"; }
                bind "n" { MovePane; }
                bind "p" { MovePaneBackwards; }
                bind "tab" { MovePane; }
            }
            scroll {
                bind "Alt left" { MoveFocusOrTab "left"; SwitchToMode "locked"; }
                bind "Alt down" { MoveFocus "down"; SwitchToMode "locked"; }
                bind "Alt up" { MoveFocus "up"; SwitchToMode "locked"; }
                bind "Alt right" { MoveFocusOrTab "right"; SwitchToMode "locked"; }
                bind "e" { EditScrollback; SwitchToMode "locked"; }
                bind "f" { SwitchToMode "entersearch"; SearchInput 0; }
                bind "Alt h" { MoveFocusOrTab "left"; SwitchToMode "locked"; }
                bind "Alt j" { MoveFocus "down"; SwitchToMode "locked"; }
                bind "Alt k" { MoveFocus "up"; SwitchToMode "locked"; }
                bind "Alt l" { MoveFocusOrTab "right"; SwitchToMode "locked"; }
                bind "s" { SwitchToMode "normal"; }
            }
            search {
                bind "c" { SearchToggleOption "CaseSensitivity"; }
                bind "n" { Search "down"; }
                bind "o" { SearchToggleOption "WholeWord"; }
                bind "p" { Search "up"; }
                bind "w" { SearchToggleOption "Wrap"; }
            }
            session {
                bind "c" {
                    LaunchOrFocusPlugin "configuration" {
                        floating true
                        move_to_focused_tab true
                    }
                    SwitchToMode "locked"
                }
                bind "d" { Detach; }
                bind "o" { SwitchToMode "normal"; }
                bind "p" {
                    LaunchOrFocusPlugin "plugin-manager" {
                        floating true
                        move_to_focused_tab true
                    }
                    SwitchToMode "locked"
                }
                bind "w" {
                    LaunchOrFocusPlugin "session-manager" {
                        floating true
                        move_to_focused_tab true
                    }
                    SwitchToMode "locked"
                }
            }
            shared_among "normal" "locked" {
                bind "Alt left" { MoveFocusOrTab "left"; }
                bind "Alt down" { MoveFocus "down"; }
                bind "Alt up" { MoveFocus "up"; }
                bind "Alt right" { MoveFocusOrTab "right"; }
                bind "Alt +" { Resize "Increase"; }
                bind "Alt -" { Resize "Decrease"; }
                bind "Alt =" { Resize "Increase"; }
                bind "Alt [" { PreviousSwapLayout; }
                bind "Alt ]" { NextSwapLayout; }
                bind "Alt f" { ToggleFloatingPanes; }
                bind "Alt h" { MoveFocusOrTab "left"; }
                bind "Alt i" { MoveTab "left"; }
                bind "Alt j" { MoveFocus "down"; }
                bind "Alt k" { MoveFocus "up"; }
                bind "Alt l" { MoveFocusOrTab "right"; }
                bind "Alt b" { NewPane; }
                bind "Alt o" { MoveTab "right"; }
            }
            shared_except "locked" "renametab" "renamepane" {
                bind "Ctrl g" { SwitchToMode "locked"; }
                bind "Ctrl q" { Quit; }
            }
            shared_except "locked" "entersearch" {
                bind "enter" { SwitchToMode "locked"; }
            }
            shared_except "locked" "entersearch" "renametab" "renamepane" {
                bind "esc" { SwitchToMode "locked"; }
            }
            shared_except "locked" "entersearch" "renametab" "renamepane" "move" {
                bind "m" { SwitchToMode "move"; }
            }
            shared_except "locked" "entersearch" "search" "renametab" "renamepane" "session" {
                bind "o" { SwitchToMode "session"; }
            }
            shared_except "locked" "tab" "entersearch" "renametab" "renamepane" {
                bind "t" { SwitchToMode "tab"; }
            }
            shared_except "locked" "tab" "scroll" "entersearch" "renametab" "renamepane" {
                bind "s" { SwitchToMode "scroll"; }
            }
            shared_among "normal" "resize" "tab" "scroll" "prompt" "tmux" {
                bind "p" { SwitchToMode "pane"; }
            }
            shared_except "locked" "resize" "pane" "tab" "entersearch" "renametab" "renamepane" {
                bind "r" { SwitchToMode "resize"; }
            }
            shared_among "scroll" "search" {
                bind "PageDown" { PageScrollDown; }
                bind "PageUp" { PageScrollUp; }
                bind "left" { PageScrollUp; }
                bind "down" { ScrollDown; }
                bind "up" { ScrollUp; }
                bind "right" { PageScrollDown; }
                bind "Ctrl b" { PageScrollUp; }
                bind "Ctrl c" { ScrollToBottom; SwitchToMode "locked"; }
                bind "d" { HalfPageScrollDown; }
                bind "Ctrl f" { PageScrollDown; }
                bind "n" { PageScrollUp; }
                bind "r" { ScrollDown; }
                bind "g" { ScrollUp; }
                bind "t" { PageScrollDown; }
                bind "u" { HalfPageScrollUp; }
            }
            entersearch {
                bind "Ctrl c" { SwitchToMode "scroll"; }
                bind "esc" { SwitchToMode "scroll"; }
                bind "enter" { SwitchToMode "search"; }
            }
            renametab {
                bind "esc" { UndoRenameTab; SwitchToMode "tab"; }
            }
            shared_among "renametab" "renamepane" {
                bind "Ctrl c" { SwitchToMode "locked"; }
            }
            renamepane {
                bind "esc" { UndoRenamePane; SwitchToMode "pane"; }
            }
        }
      '';
    };

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
    bash = {
      enable = true;
      initExtra = ''
        if command -v fish > /dev/null 2>&1; then
          exec fish
        fi
      '';
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    eza.enable = true;

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

    zellij = { enable = true; };

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
