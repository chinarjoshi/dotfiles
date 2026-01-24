{ pkgs, config, lib, emacs-config, ... }:

{
  home.stateVersion = "24.11";

  programs.lf = {
    enable = true;
    extraConfig = ''
      cmd open ''${{ $EDITOR $f }}

      map d
      map d delete
    '';
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Chinar Joshi";
        email = "chinarjoshi7@gmail.com";
      };
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
  };

  programs.delta = {
    enable = true;
    options = {
      navigate = true;
      light = false;
      side-by-side = true;
      line-numbers = true;
    };
  };

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
        V = [ "goto_first_nonwhitespace" "extend_to_line_end" "select_mode" ];
        X = "extend_line_up";
        space.q = ":quit";
        space.w = ":write";
      };
      keys.select = {
        ";" = [ "collapse_selection" "normal_mode" ];
      };
    };
    languages = {
      language-server.jdtls = {
        command = "jdt-language-server";
        args = [ "-data" "${config.home.homeDirectory}/.cache/jdtls/workspace" ];
      };
      language = [{
        name = "java";
        scope = "source.java";
        injection-regex = "java";
        file-types = [ "java" ];
        roots = [ "pom.xml" "build.gradle" ];
        indent = { tab-width = 4; unit = "    "; };
        language-servers = [ "jdtls" ];
      }];
    };
    themes = {
      material_midnight = ''
        inherits = "material_deep_ocean"
        "ui.background" = "#000000"
      '';
    };
  };

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    envExtra = ''
      export DOTFILES=$HOME/.config
      export EDITOR='emacsclient'
      export AUTOENV_ASSUME_YES='1'
    '';

    initContent = ''
      export HISTFILE=~/.histfile
      setopt appendhistory INC_APPEND_HISTORY SHARE_HISTORY PROMPT_SUBST autocd extended_glob
      unsetopt extended_history beep
      autoload -Uz compinit && compinit
      zstyle ':completion:*' matcher-list ''' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

      ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
      typeset -A ZSH_HIGHLIGHT_STYLES
      ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=white

      PROMPT='%F{blue}''${''${''${PWD/#''$HOME/}#/}:-.}%f
''$ '

      bindkey -e
      autoload -Uz select-word-style
      select-word-style bash

      echo -e '\e[6 q'

      if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
          vterm_prompt_end() { printf "\e]51;A%s@%s:%s\e\\" "$USER" "$HOST" "$PWD" }
          precmd_functions+=(vterm_prompt_end)
      fi
    '';

    plugins = [{
      name = "zsh-syntax-highlighting";
      src = pkgs.zsh-syntax-highlighting;
      file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
    }];

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

      # Utilities
      e = "emacsclient -c";
      n = "nvim";
      l = "ls -lAFgG --color=auto";
      c = "npx @anthropic-ai/claude-code";
      python = "python3";
    };
  };

  services.emacs = {
    enable = true;
    client.enable = true;
    package = emacs-config.packages.${pkgs.stdenv.hostPlatform.system}.emacs;
  };

  home.packages = with pkgs; [
    emacs-config.packages.${pkgs.stdenv.hostPlatform.system}.default
    btop
    fzf
    tree
    zip
    unzip
    fd
    ripgrep
    tealdeer
    jq
  ];
}
