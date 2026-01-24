{ pkgs, config, lib, ... }:

{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "Inconsolata:size=12";
      };
      colors = {
        background = "000000";
      };
    };
  };

  programs.zsh = {
    envExtra = lib.mkAfter ''
      export QT_QPA_PLATFORM='wayland'
      export XDG_SESSION_TYPE='wayland'
      export XDG_CURRENT_DESKTOP='sway'
      export MOZ_ENABLE_WAYLAND='1'
      export OBSIDIAN_USE_WAYLAND='1'
      export GOOGLE_CRED_JSON=~/.config/neuralinux-6d4f71825a6d.json
    '';

    shellAliases = {
      hnix = "$EDITOR ${config.home.homeDirectory}/nixos/configuration.nix";
      hhome = "$EDITOR ${config.home.homeDirectory}/nixos/home/common.nix";
      sudo = "doas";
      rebuild = "doas nixos-rebuild switch --flake '${config.home.homeDirectory}/nixos#XPS'";
      toggle-scale = ''current=$(swaymsg -t get_outputs -r | jq -r ".[] | select(.name==\"eDP-1\") | .scale"); swaymsg "output eDP-1 scale $((3 - current))"'';
      silksong = "steam steam://rungameid/1030300";
    };

    initContent = ''
      speakers() {
        local dev=''$(bluetoothctl devices | grep -i 'fosi' | awk '{print $2}')
        bluetoothctl info "$dev" | grep -q "Connected: yes" && \
        bluetoothctl disconnect "$dev" || \
        bluetoothctl connect "$dev"
      }
    '';
  };

  services.swayidle = {
    enable = true;
    events = {
      before-sleep = "${pkgs.systemd}/bin/systemctl suspend";
    };
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

  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "foot";
      fonts = {
        names = [ "Inconsolata" ];
        size = 11.0;
      };

      startup = [
        { command = "wlsunset -l 37.4 -L -112.2"; always = true; }
        { command = "python3 ${config.home.homeDirectory}/.config/sway/dim.py -o .8"; always = true; }
        { command = "${pkgs.autotiling-rs}/bin/autotiling-rs"; always = true; }
      ];

      window.border = 0;
      focus.mouseWarping = "container";

      assigns = {
        "10" = [{ app_id = "obsidian"; }];
      };

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
        "${mod}+Return" = "exec emacsclient -c -e '(vterm-full)'";
        "${mod}+Shift+Return" = "exec foot";
        "${mod}+Space" = "exec firefox";
        "${mod}+Tab" = "workspace back_and_forth";
        "${mod}+q" = "kill";
        "${mod}+Shift+c" = "reload";
        "${mod}+s" = "exec grim -g \"$(slurp)\" - | swappy -f -";
        "${mod}+o" = "exec obsidian";
        "${mod}+e" = "exec emacsclient -c -e '(notes-open-daily)'";
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
        "${mod}+Shift+b" = "bluetoothctl connect $(bluetoothctl devices | grep -i 'fosi' | awk '{print $2}')";

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
        "${mod}+0" = "workspace number 10";

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

        # Etc
        "${mod}+f" = "fullscreen";
        "${mod}+r" = "mode resize";
        "${mod}+Control+s" = "exec steam steam://rungameid/1030300";
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

  home.file.".config/sway/bar.sh" = {
    source = ./config-files/sway/bar.sh;
    executable = true;
  };
  home.file.".config/sway/dim.py" = {
    source = ./config-files/sway/dim.py;
    executable = true;
  };

  home.packages = with pkgs; [
    obsidian
    wl-clipboard
    grim
    slurp
    swappy
  ];
}
