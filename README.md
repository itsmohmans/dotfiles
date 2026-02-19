# dotfiles

Personal configuration files for an EndeavourOS/Arch Linux setup running Zsh, Alacritty, and Tmux.

Config-only. Symlinks are managed by a single `install.sh` script; everything else (packages, plugins) is installed through its own upstream tooling.

## Repository layout

```sh
dotfiles/
├── install.sh          # bootstrap script
├── README.md
├── alacritty/          # Alacritty terminal config + vendored theme(s)
│   ├── alacritty.toml
│   └── themes/
│       └── thelovelace.toml
├── tmux/
│   └── tmux.conf       # Tmux config (plugins managed via TPM)
├── scripts/            # custom scripts 
│   └── tmux_session.sh # auto-attach / create a default tmux session
└── zsh/
    ├── .zshrc          # thin loader - sources everything below
    ├── exports.zsh
    ├── path.zsh
    ├── aliases.zsh
    ├── functions.zsh
    └── tools/
        ├── nvm.zsh
        ├── conda.zsh
        └── thefuck.zsh
```

## Required packages

Install with `pacman` (or your AUR helper of choice):

| Package | Purpose | Arch package |
| --------- | --------- | ------------- |
| [zsh](https://www.zsh.org/)* | Shell | `zsh` |
| [Oh My Zsh](https://ohmyz.sh/)* | Zsh framework | install script (see below) |
| [tmux](https://github.com/tmux/tmux)* | Terminal multiplexer | `tmux` |
| [git](https://git-scm.com/)* | Version control | `git` |
| [Alacritty](https://alacritty.org/)* | GPU-accelerated terminal | `alacritty` |
| [eza](https://eza.rocks/) | Modern `ls` replacement | `eza` |
| [bat](https://github.com/sharkdp/bat) | Modern `cat` replacement | `bat` |
| [onefetch](https://github.com/o2sh/onefetch) | Git repo summary on `cd` | `onefetch` |
| [thefuck](https://github.com/nvbn/thefuck) | Command correction | `thefuck` |
| [xclip](https://github.com/astrand/xclip) | Clipboard from terminal | `xclip` |
| [glow](https://github.com/charmbracelet/glow) | Markdown reader | `glow` |
| [pass](https://www.passwordstore.org/) | Password manager | `pass` |
| [flatpak](https://flatpak.org/) | App sandboxing | `flatpak` |
| [rclone](https://rclone.org/) | Cloud sync | `rclone` |

*Packages marked with \* are essential obviously, the rest are optional.*

```bash
sudo pacman -S zsh tmux git alacritty eza bat onefetch thefuck xclip glow pass flatpak rclone
```

## Zsh setup

### 1. Install Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### 2. Set Zsh as default shell

```bash
chsh -s "$(which zsh)"
```

### 3. Reload

Log out and back in, or run:

```bash
source ~/.zshrc
```

## Alacritty

### Font

The config uses **Monaspace Argon**. Install it from the
[Monaspace releases page](https://github.com/githubnext/monaspace/releases)
or from the AUR:

```bash
sudo pacman -S ttf-monaspace-variable
```

Or use your own font and add it to `alacritty.toml`.

### Theme

The terminal color scheme is **The Lovelace**, vendored in
`alacritty/themes/thelovelace.toml`.
The upstream source is the
[alacritty/alacritty-theme](https://github.com/alacritty/alacritty-theme)
repository. To update the theme, copy the latest version from there into
`alacritty/themes/` (and update the theme reference in `alacritty.toml`).

### Shell integration

Alacritty is configured to launch `scripts/tmux_session.sh` as its shell
program. Every new Alacritty window automatically joins (or creates) a shared
tmux session called `initial_session`.

## Tmux

### Prefix key

The prefix here is **`Ctrl+Space`** (not the default `Ctrl+b`).

### Plugins (via TPM)

| Plugin | Purpose |
| -------- | --------- |
| [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible) | Sensible defaults |
| [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) | Save / restore sessions with `<prefix> + s / <prefix> + r` |
| [catppuccin/tmux](https://github.com/catppuccin/tmux) | Catppuccin Frappé status bar theme |
| [tmux-battery](https://github.com/tmux-plugins/tmux-battery) | Battery indicator |

### Installing plugins

TPM is auto-installed by `install.sh`. After that, open tmux and type:

```txt
<prefix> + I
```

(`Ctrl+Space`, then `Shift+i`)

This fetches and installs every plugin listed in `tmux.conf`.

### Reloading config

```bash
tmux source ~/.config/tmux/tmux.conf
```

Or use the alias:

```bash
remux
```

## Installation

```bash
git clone https://github.com/itsmohmans/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

The script will:

1. Symlink `~/.zshrc` → `~/dotfiles/zsh/.zshrc`
2. Symlink `~/.config/alacritty` → `~/dotfiles/alacritty`
3. Symlink `~/.config/tmux` → `~/dotfiles/tmux`
4. Symlink each script in `scripts/` → `~/.local/bin/`
5. Clone TPM if not already present

Existing files are backed up with a `.bak-<timestamp>` suffix so worry not, nothing is silently overwritten.
