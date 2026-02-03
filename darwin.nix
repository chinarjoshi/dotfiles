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
    onActivation.cleanup = "zap";
    taps = [ "d12frosted/emacs-plus" ];
    casks = [ "emacs-plus-app" "rectangle" "hammerspoon" ];
  };

  environment.systemPackages = [
    pkgs.libtool
    glibtool
    pkgs.iproute2mac
  ];

  programs.zsh.enable = true;
  users.users.chijoshi.shell = pkgs.zsh;

  system.defaults.CustomUserPreferences = {
    "com.google.Chrome" = {
      NSUserKeyEquivalents = {
        "Find..." = "^f";
      };
    };
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

  launchd.user.agents.emacs = {
    command = "/bin/zsh -l -c 'cd /Users/chijoshi && /opt/homebrew/bin/emacs --fg-daemon'";
    serviceConfig = {
      RunAtLoad = true;
      KeepAlive = true;
      WorkingDirectory = "/Users/chijoshi";
    };
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.chijoshi = { config, pkgs, ... }: {
    imports = [ ./common.nix ];

    home.username = "chijoshi";
    home.homeDirectory = lib.mkForce "/Users/chijoshi";

    home.file.".hammerspoon/init.lua".text = ''
      -- map hjkl to the corresponding focusWindow methods
      local dirMap = {
        h = "West",
        j = "South",
        k = "North",
        l = "East",
      }

      for key, dir in pairs(dirMap) do
        hs.hotkey.bind({"cmd"}, key, function()
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
    '';
  };
}
