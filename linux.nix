{ pkgs, config, lib, ... }:

let
  barScript = pkgs.writeShellScript "sway-bar" ''
    while true; do
      battery=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null)
      battery_status=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null)
      if [[ $battery_status == "Charging" ]]; then
        battery="$battery%*"
      else
        battery="$battery%"
      fi

      volume=$(${pkgs.pulseaudio}/bin/pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1)
      muted=$(${pkgs.pulseaudio}/bin/pactl get-sink-mute @DEFAULT_SINK@ | grep -o "yes")
      if [[ $muted == "yes" ]]; then
        volume="M"
      fi

      time=$(date "+%I:%M")
      echo "$battery | $volume | $time"
      sleep 1
    done
  '';
in {
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

  services.avizo = {
    enable = true;
    settings = {
      default = {
        time = 0.5;
        width = 200;
        height = 200;
        padding = 20;
        y-offset = 0.5;
        fade-in = 0.1;
        fade-out = 0.2;
        background = "rgba(0, 0, 0, 0.8)";
        bar-fg-color = "rgba(102, 102, 102, 1)";
        bar-bg-color = "rgba(50, 50, 50, 1)";
      };
    };
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
        { command = "${pkgs.sway-contrib.inactive-windows-transparency}/bin/inactive-windows-transparency.py -o 0.8"; always = true; }
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
        "${mod}+Return" = "exec emacsclient -c -e '(vterm-full-toggle)'";
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
        "${mod}+Up" = "exec lightctl up 1";
        "${mod}+Down" = "exec lightctl down 1";
        "XF86MonBrightnessUp" = "exec lightctl up 3";
        "XF86MonBrightnessDown" = "exec lightctl down 3";

        # Audio
        "XF86AudioRaiseVolume" = "exec volumectl up 5";
        "XF86AudioLowerVolume" = "exec volumectl down 5";
        "XF86AudioMute" = "exec volumectl toggle-mute";
        "${mod}+Shift+Up" = "exec volumectl toggle-mute";
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
        statusCommand = "${barScript}";
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

  home.packages = with pkgs; [
    obsidian
    wl-clipboard
    grim
    slurp
    swappy
    libvterm
  ];
}
