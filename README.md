# Dotfiles Configuration

This directory contains two NixOS configuration files:

## Files

- **`configuration.nix`** - Full NixOS system configuration (requires root)
- **`home.nix`** - Portable home-manager configuration (works without root)

## Usage

### On NixOS Systems (with root access)

Use the standard rebuild command:

```bash
doas nixos-rebuild switch
```

This will apply both the system configuration and your home configuration.

### On Non-NixOS Systems (without root access)

Perfect for work laptops or systems where you don't have root access!

#### Initial Setup

1. Install Nix (if not already installed):
```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

2. Add home-manager channel:
```bash
nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager
nix-channel --update
```

3. Install home-manager:
```bash
nix-shell '<home-manager>' -A install
```

4. Copy your config files:
```bash
# Copy home.nix and any referenced files to your work machine
# You'll need at minimum:
# - ~/.config/nixos/home.nix
# - ~/.config/zsh/plugins/theme/.p10k.zsh
# - ~/.config/zsh/plugins/sudo.zsh
```

5. Apply the configuration:
```bash
home-manager switch -f ~/.config/nixos/home.nix
```

#### What Works Standalone

On a non-NixOS system, you'll get:
- ✅ Zsh with Powerlevel10k theme
- ✅ All your git aliases and shell configurations
- ✅ LF file manager configuration
- ✅ All the packages in `home.packages`
- ✅ Your development tools and language servers

What won't work (requires NixOS/root):
- ❌ Sway window manager
- ❌ Swayidle service
- ❌ Foot terminal (may work if you install it separately)
- ❌ System-level services

#### Updating Configuration

After making changes to `home.nix`:

```bash
home-manager switch -f ~/.config/nixos/home.nix
```

## Tips

### Sharing Config Between Machines

Keep your `home.nix` in git and you can:
1. Clone it on any machine
2. Run `home-manager switch -f path/to/home.nix`
3. Instantly get your shell, aliases, and tools

### Making home.nix More Portable

If you want to disable sway/swayidle on non-NixOS systems, add this to `home.nix`:

```nix
{ pkgs, config, lib, ... }:

let
  isNixOS = builtins.pathExists /etc/NIXOS;
in
{
  # Your existing config...

  # Only enable GUI stuff on NixOS
  wayland.windowManager.sway.enable = lib.mkIf isNixOS true;
  services.swayidle.enable = lib.mkIf isNixOS true;
  programs.foot.enable = lib.mkIf isNixOS true;
}
```

### Rollback

**On NixOS:**
```bash
doas nixos-rebuild --rollback
```

**Standalone home-manager:**
```bash
home-manager generations
home-manager switch --switch-generation <number>
```
