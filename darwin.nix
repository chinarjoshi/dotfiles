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
      -- Focus windows
      local function focusDirection(dir)
        local win = hs.window.focusedWindow()
        if not win then return end
        if dir == "west" then win:focusWindowWest(nil, true) end
        if dir == "east" then win:focusWindowEast(nil, true) end
        if dir == "north" then win:focusWindowNorth(nil, true) end
        if dir == "south" then win:focusWindowSouth(nil, true) end
      end

      hs.hotkey.bind({"cmd"}, "h", function() focusDirection("west") end)
      hs.hotkey.bind({"cmd"}, "j", function() focusDirection("south") end)
      hs.hotkey.bind({"cmd"}, "k", function() focusDirection("north") end)
      hs.hotkey.bind({"cmd"}, "l", function() focusDirection("east") end)

      -- App launchers
      hs.hotkey.bind({"cmd"}, "return", function()
        hs.execute("/opt/homebrew/bin/emacsclient -c -n --eval '(vterm-full-toggle)'", true)
      end)
      hs.hotkey.bind({"cmd", "shift"}, "return", function() hs.application.launchOrFocus("Kitty") end)
      hs.hotkey.bind({"cmd", "shift"}, "space", function() hs.application.launchOrFocus("Google Chrome") end)
      hs.hotkey.bind({"cmd"}, "e", function()
        hs.execute("/opt/homebrew/bin/emacsclient -c -n --eval '(notes-open-daily)'", true)
      end)

      -- Close window
      hs.hotkey.bind({"cmd"}, "q", function()
        local win = hs.window.focusedWindow()
        if win then win:close() end
      end)

      -- Screenshot
      hs.hotkey.bind({"cmd"}, "s", function()
        local filename = os.date("~/Desktop/screenshot-%Y%m%d-%H%M%S.png")
        hs.execute("screencapture -i " .. filename)
      end)

      -- Reload config
      hs.hotkey.bind({"cmd", "shift"}, "c", function() hs.reload() end)
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
