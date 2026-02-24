{ pkgs, config, ... }:

{
  home.stateVersion = "24.11";

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
      line-numbers = true;
    };
  };

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    envExtra = ''
      export PATH="$HOME/.local/bin:$HOME/.cargo/bin:/opt/homebrew/bin:$PATH"
      export DOTFILES=$HOME/.config
      export EDITOR='emacsclient'
      export ALTERNATE_EDITOR='vim'
      export AUTOENV_ASSUME_YES='1'
      [ -f ~/.env ] && source ~/.env
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

      function __emacs_check { pgrep -qfi 'emacs.*daemon' || echo -n '%F{red}[E!] %f' }
      PROMPT='$(__emacs_check)%F{blue}''${''${''${PWD/#''$HOME/}#/}:-.}%f
''$ '

      bindkey -e
      autoload -Uz select-word-style
      select-word-style bash
      zstyle ':zle:backward-kill-word' word-style whitespace

      backward-kill-bash-word() {
        local WORDCHARS='''
        zle .backward-kill-word
      }
      zle -N backward-kill-bash-word
      bindkey '^[^?' backward-kill-bash-word

      echo -e '\e[6 q'

      if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
          vterm_prompt_end() { printf "\e]51;A%s@%s:%s\e\\" "$USER" "$HOST" "$PWD" }
          vterm_set_title() { print -Pn "\e]2;%2~\a" }
          vterm_preexec_title() { print -Pn "\e]2;''${1%% *}\a" }
          precmd_functions+=(vterm_prompt_end vterm_set_title)
          preexec_functions+=(vterm_preexec_title)
      fi
    '';

    plugins = [{
      name = "zsh-syntax-highlighting";
      src = pkgs.zsh-syntax-highlighting;
      file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
    }];

    shellAliases = {
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
      e = "emacsclient -cn";
      emacs-open = "emacsclient -cn";
      emacs-kill = "emacsclient -e '(kill-emacs)'";
      l = "ls -lAFgG --color=auto";
      c = "claude --dangerously-skip-permissions";
      python = "python3";
    };
  };

  home.packages = with pkgs; [
    arp-scan
    arping
    btop
    cargo
    clang-tools
    cmake
    dbmate
    emacs-lsp-booster
    fd
    fzf
    gcc
    git-lfs
    gnumake

    golangci-lint
    golines
    gopls
    grpc
    grpcurl
    inter
    jq
    libiconv
    libpq
    lua-language-server
    nerd-fonts.inconsolata
    nmap
    vim
    nodePackages.bash-language-server
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages.yaml-language-server
    nodejs
    pdsh
    postgresql_14
    pre-commit
    pyright
    ripgrep
    ruff
    sqlc
    squashfsTools
    taplo
    tealdeer
    tree
    unzip
    uv
    wget
    yarn
    zip
    bun
    gh
  ];
}
