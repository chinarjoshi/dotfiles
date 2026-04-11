{ config, lib, pkgs, ... }:

let
  glibtool = pkgs.runCommand "glibtool" {} ''
    mkdir -p $out/bin
    ln -s ${pkgs.libtool}/bin/libtool $out/bin/glibtool
    ln -s ${pkgs.libtool}/bin/libtoolize $out/bin/glibtoolize
  '';
in
{
  system.stateVersion = 5;
  system.primaryUser = "chijoshi";
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  homebrew = {
    enable = true;
    onActivation.cleanup = "none";
    casks = [ "rectangle" "hammerspoon" "karabiner-elements" ];
  };

  programs.zsh.enable = true;
  users.users.chijoshi.shell = pkgs.zsh;

  system.defaults.CustomUserPreferences = {
    "com.knollsoft.Rectangle" = {
      # cmd + shift + h = left half (keyCode 4 = h, modifierFlags 1179648 = cmd+shift)
      leftHalf = {
        keyCode = 4;
        modifierFlags = 1179648;
      };
      # cmd + shift + l = right half (keyCode 37 = l)
      rightHalf = {
        keyCode = 37;
        modifierFlags = 1179648;
      };
    };
    # Ctrl+1/2 to switch spaces (used by Hammerspoon Cmd+Tab toggle)
    "com.apple.symbolichotkeys" = {
      AppleSymbolicHotKeys = {
        "118" = { enabled = true; value = { parameters = [49 18 262144]; type = "standard"; }; };
        "119" = { enabled = true; value = { parameters = [50 19 262144]; type = "standard"; }; };
      };
    };
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.chijoshi = { config, pkgs, ... }: {
    imports = [ ./common.nix ];

    home.username = "chijoshi";
    home.homeDirectory = lib.mkForce "/Users/chijoshi";

    home.file.".config/karabiner/karabiner.json".text = builtins.toJSON {
      global.check_for_updates_on_startup = false;
      profiles = [{
        name = "Default";
        selected = true;
        virtual_hid_keyboard.keyboard_type_v2 = "ansi";
        complex_modifications.rules = [
          {
            description = "Caps Lock → Escape (tap) / Left Control (hold)";
            manipulators = [{
              type = "basic";
              from = {
                key_code = "caps_lock";
                modifiers.optional = [ "any" ];
              };
              to = [{ key_code = "left_control"; lazy = true; }];
              to_if_alone = [{ key_code = "escape"; }];
            }];
          }
          {
            description = "Ctrl+K → Cmd+K";
            manipulators = [{
              type = "basic";
              from = {
                key_code = "k";
                modifiers = {
                  mandatory = [ "control" ];
                  optional = [ "caps_lock" ];
                };
              };
              to = [{
                key_code = "k";
                modifiers = [ "left_command" ];
              }];
            }];
          }
        ];
      }];
    };

    home.file.".hammerspoon/init.lua".text = ''
      -- map hjkl to the corresponding focusWindow methods
      local dirMap = {
        h = "West",
        j = "South",
      }

      local hotkeys = {}
      for key, dir in pairs(dirMap) do
        hotkeys[key] = hs.hotkey.bind({"cmd"}, key, function()
          local win = hs.window.focusedWindow()
          if not win then return end

          -- invoke win:focusWindow<Dir>()
          local method = "focusWindow" .. dir
          win[method](win)

          local win = hs.window.focusedWindow()
          -- warp mouse to center
          local f = win:frame()
          hs.mouse.setAbsolutePosition({
            x = f.x + f.w/2,
            y = f.y + f.h/2,
          })
        end)
      end

      -- Cmd+K / Ctrl+L -> Cmd+L (focus address bar in Chrome etc.)
      local function sendCmdL()
        hs.eventtap.keyStroke({"cmd"}, "l", 0)
      end
      hs.hotkey.bind({"cmd"}, "k", sendCmdL)
      hs.hotkey.bind({"ctrl"}, "l", sendCmdL)

      -- Cmd+Tab to toggle between space 1 and 2 (uses native Ctrl+1/2 for speed)
      local currentSpace = 1
      cmdTabWatcher = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
        local flags = event:getFlags()
        if flags.cmd and not flags.shift and not flags.alt and not flags.ctrl and event:getKeyCode() == 48 then
          currentSpace = currentSpace == 1 and 2 or 1
          hs.eventtap.keyStroke({"ctrl"}, tostring(currentSpace), 0)
          return true
        end
        return false
      end)
      cmdTabWatcher:start()

    '';

    programs.zsh.shellAliases = {
      rebuild = "sudo darwin-rebuild switch --flake '${config.home.homeDirectory}/nixos#mac'";
    };

    programs.zsh.initContent = ''
      unsetopt BEEP
      unsetopt HIST_BEEP
      unsetopt LIST_BEEP
      export LIBRARY_PATH="/opt/homebrew/lib/gcc/current''${LIBRARY_PATH:+:$LIBRARY_PATH}"
      export PATH="/opt/homebrew/bin:/opt/homebrew/opt/go@1.22/bin:$PATH"
      export SSH_SK_PROVIDER=/usr/local/lib/sk-libfido2.dylib
      [ -f ~/.aliases.sh ] && . ~/.aliases.sh
    '';
  };

  environment.systemPackages = [
    pkgs.libtool
    glibtool
    pkgs.iproute2mac
    pkgs.freerdp
  ];
}
