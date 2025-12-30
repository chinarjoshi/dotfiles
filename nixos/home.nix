{ pkgs, config, lib, emacs-config, ... }:

{
  home.stateVersion = "24.11";

  # Alacritty Terminal
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "Inconsolata";
        };
        size = 14;
      };
      colors = {
        primary = {
          background = "#000000";
        };
      };
    };
  };

  # LF File Manager
  programs.lf = {
    enable = true;
    extraConfig = ''
      cmd open ''${{ $EDITOR $f }}

      map d
      map d delete
    '';
  };

  # Git
  programs.git = {
    enable = true;
    userName = "Chinar Joshi";
    userEmail = "chinarhjoshi@gmail.com";
    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
        side-by-side = true;
        line-numbers = true;
      };
    };
    extraConfig = {
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
  };

  # Helix Editor
  programs.helix = {
    enable = true;
    settings = {
      theme = "material_midnight";
      editor.cursor-shape = {
        insert = "bar";
        select = "underline";
      };
      editor.soft-wrap.enable = true;
      keys.normal = {
        V = ["goto_first_nonwhitespace" "extend_to_line_end" "select_mode"];
        X = "extend_line_up";
        space.q = ":quit";
        space.w = ":write";
      };
      keys.select = {
        ";" = ["collapse_selection" "normal_mode"];
      };
    };
    languages = {
      language-server.jdtls = {
        command = "jdt-language-server";
        args = ["-data" "/home/c/.cache/jdtls/workspace"];
      };
      language = [{
        name = "java";
        scope = "source.java";
        injection-regex = "java";
        file-types = ["java"];
        roots = ["pom.xml" "build.gradle"];
        indent = { tab-width = 4; unit = "    "; };
        language-servers = ["jdtls"];
      }];
    };
    themes = {
      material_midnight = ''
        inherits = "material_deep_ocean"
        "ui.background" = "#000000"
      '';
    };
  };

  # Zsh with Powerlevel10k
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";

    envExtra = ''
      export DOTFILES=$HOME/.config
      export EDITOR='emacsclient'
      export QT_QPA_PLATFORM='wayland'
      export XDG_CONFIG_HOME="$HOME/.config"
      export XDG_SESSION_TYPE='wayland'
      export XDG_CURRENT_DESKTOP='sway'
      export MOZ_ENABLE_WAYLAND='1'
      export AUTOENV_ASSUME_YES='1'
      export OBSIDIAN_USE_WAYLAND='1'
      export GOOGLE_CRED_JSON=~/.config/neuralinux-6d4f71825a6d.json
    '';

    initExtraFirst = ''
      # P10k instant prompt
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
      typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
    '';

    initExtra = ''
      # Settings
      export HISTFILE=~/.histfile
      setopt appendhistory
      setopt INC_APPEND_HISTORY
      setopt SHARE_HISTORY
      setopt autocd
      setopt extended_glob
      unsetopt extended_history
      unsetopt beep
      autoload -Uz compinit && compinit
      zstyle ':completion:*' matcher-list ''' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

      # Syntax highlighting settings
      ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
      typeset -A ZSH_HIGHLIGHT_STYLES
      ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=white

      # Load P10k config
      [[ -f ${config.home.homeDirectory}/.config/zsh/.p10k.zsh ]] && source ${config.home.homeDirectory}/.config/zsh/.p10k.zsh

      # Load custom plugins
      for file in $ZDOTDIR/plugins/*.zsh(N); do
        source $file
      done

      bindkey -e
      autoload -Uz select-word-style
      select-word-style bash
    '';

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
    ];

    shellAliases = {
      # Git aliases
      ga = "git add";
      gau = "git add -u";
      gc = "git commit";
      gC = "git commit --amend --no-edit";
      gd = "git diff";
      gch = "git checkout";
      gchb = "git checkout -b";
      gll = "git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      gl = "gll -n5";
      gpu = "git push";
      grh = "git reset --hard";
      gs = "git status";
      gpl = "git pull";
      gdh = "git diff HEAD~";
      gds = "git diff --staged";
      gst = "git stash";
      gb = "git branch";
      gres = "git restore";

      # Config editing
      hsway = "$EDITOR /home/c/.config/sway/config";
      hzsh = "$EDITOR /home/c/.config/zsh/.zshrc";
      hnix = "$EDITOR /home/c/.config/nixos/configuration.nix";
      hkitty = "$EDITOR /home/c/.config/kitty/kitty.conf && kill -SIGUSR1 $KITTY_PID";

      # Utilities
      l = "ls -lAFgG --color=auto";
      n = "nvim";
      c = "npx @anthropic-ai/claude-code";
      e = "emacsclient";
      sudo = "doas";
      python = "python3";
    };
  };

  # Emacs daemon service
  services.emacs = {
    enable = true;
    client.enable = true;
    package = emacs-config.packages.${pkgs.system}.emacs;
  };

  # Swayidle Service
  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "${pkgs.systemd}/bin/systemctl suspend"; }
    ];
    timeouts = [
      {
        timeout = 120;
        command = "${pkgs.sway}/bin/swaymsg \"output * dpms off\"";
        resumeCommand = "${pkgs.sway}/bin/swaymsg \"output * dpms on\"";
      }
      {
        timeout = 240;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
  };

  # Sway Window Manager
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "alacritty";
      fonts = {
        names = [ "Inconsolata" ];
        size = 11.0;
      };

      startup = [
        { command = "wlsunset -l 37.4 -L -112.2"; always = true; }
        { command = "python3 ${config.home.homeDirectory}/.config/sway/dim.py -o .8"; always = true; }
      ];

      window.border = 0;
      focus.mouseWarping = "container";

      seat."*" = {
        xcursor_theme = "Adwaita 24";
      };

      input = {
        "*" = {
          xkb_options = "altwin:swap_alt_win";
          repeat_delay = "250";
          repeat_rate = "30";
          natural_scroll = "enabled";
          scroll_factor = "0.15";
          tap = "enabled";
          pointer_accel = "0.3";
        };
        "type:pointer" = {
          scroll_factor = ".5";
          pointer_accel = "0.1";
        };
      };

      output = {
        "eDP-1" = {
          pos = "0 0";
          scale = "2";
        };
        "DP-1" = {
          mode = "2560x1440@60Hz";
          scale = "1";
          pos = "-416 -1440";
        };
      };

      keybindings = let
        mod = "Mod4";
      in {
        "${mod}+Return" = "splith; exec alacritty";
        "${mod}+Space" = "splith; exec firefox";
        "${mod}+Shift+Return" = "splitv; exec alacritty";
        "${mod}+Shift+Space" = "splitv; exec firefox";
        "${mod}+Tab" = "workspace back_and_forth";
        "${mod}+q" = "kill";
        "${mod}+Shift+c" = "reload";
        "${mod}+s" = "exec grim -g \"$(slurp)\" - | swappy -f -";
        "${mod}+o" = "exec obsidian";
        "${mod}+Shift+s" = "exec systemctl suspend";
        "${mod}+Shift+q" = "exec poweroff";
        "${mod}+Shift+Control+r" = "exec systemctl reboot";

        # Focus
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";

        # Move
        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";

        # Brightness
        "${mod}+Up" = "exec doas light -A 1";
        "${mod}+Down" = "exec doas light -U 1";
        "XF86MonBrightnessUp" = "exec doas light -A 3";
        "XF86MonBrightnessDown" = "exec doas light -U 3";

        # Audio
        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +10%";
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -10%";
        "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "${mod}+Shift+Up" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";

        # Workspaces
        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";

        # Move to workspace
        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
        "${mod}+Shift+0" = "move container to workspace number 10";

        "${mod}+f" = "fullscreen";
        "${mod}+r" = "mode resize";
      };

      modes = {
        resize = {
          "h" = "resize shrink width 10px";
          "j" = "resize grow height 10px";
          "k" = "resize shrink height 10px";
          "l" = "resize grow width 10px";
          "Return" = "mode default";
          "Escape" = "mode default";
        };
      };

      bars = [{
        position = "top";
        statusCommand = "${config.home.homeDirectory}/.config/sway/bar.sh";
        fonts = {
          names = [ "Inconsolata" ];
          size = 14.0;
        };
        colors = {
          statusline = "#666666";
          background = "#000000";
          inactiveWorkspace = {
            background = "#32323200";
            border = "#32323200";
            text = "#5c5c5c";
          };
        };
      }];
    };

    extraConfig = ''
      default_border none
      default_floating_border none
      include /etc/sway/config.d/*
    '';
  };

  # File symlinks for scripts and configs
  home.file.".config/zsh/.p10k.zsh".source = /home/c/.config/zsh/plugins/theme/.p10k.zsh;
  home.file.".config/zsh/plugins/sudo.zsh".source = /home/c/.config/zsh/plugins/sudo.zsh;

  home.file.".config/sway/bar.sh" = {
    source = /home/c/.config/sway/bar.sh;
    executable = true;
  };
  home.file.".config/sway/dim.py" = {
    source = /home/c/.config/sway/dim.py;
    executable = true;
  };

  # User packages
  home.packages = with pkgs; [
    # Emacs from flake
    emacs-config.packages.${pkgs.system}.default

    # User-specific tools
    btop
    fzf
    tree
    zip
    unzip
    obsidian
    wl-clipboard
    grim
    slurp
    swappy
    fd
    ripgrep
    tealdeer
    jq
    dropbox-cli
  ];
}
