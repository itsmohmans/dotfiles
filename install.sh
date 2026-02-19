#!/usr/bin/env bash
# ----------------------------------------------------------------
# install.sh - install and link dotfiles in this repo
# ---------------------------------------------------------------
set -euo pipefail

# -- Helpers ----------------------------------------------------

TIMESTAMP="$(date +%Y%m%d%H%M%S)"

info()  { printf '  \033[1;34m→\033[0m %s\n' "$1"; }
ok()    { printf '  \033[1;32m✓\033[0m %s\n' "$1"; }
warn()  { printf '  \033[1;33m!\033[0m %s\n' "$1"; }
err()   { printf '  \033[1;31m✗\033[0m %s\n' "$1"; }

# Resolve the directory this script lives in (= repo root).
DOTFILES="$(cd "$(dirname "$0")" && pwd)"

backup_and_link() {
  # $1 = link target (source inside dotfiles)
  # $2 = link name  (destination path)
  local target="$1"
  local link="$2"

  if [ -L "$link" ]; then
      # Already a symlink - check if it points to the right place.
      if [ "$(readlink "$link")" = "$target" ]; then
          ok "$link already linked"
          return
      fi
      warn "$link is a symlink to $(readlink "$link"), replacing"
      rm "$link"
  elif [ -e "$link" ]; then
      local backup="${link}.bak-${TIMESTAMP}"
      warn "Backing up existing $link → $backup"
      mv "$link" "$backup"
  fi

  ln -s "$target" "$link"
  ok "Linked $link → $target"
}

# -- Zsh --------------------------------------------------------

printf '\n\033[1m[ Zsh ]\033[0m\n'
backup_and_link "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"

# -- Alacritty -------------------------------------------------

printf '\n\033[1m[ Alacritty ]\033[0m\n'
mkdir -p "$HOME/.config"
backup_and_link "$DOTFILES/alacritty" "$HOME/.config/alacritty"

# -- Tmux -------------------------------------------------------

printf '\n\033[1m[ Tmux ]\033[0m\n'
mkdir -p "$HOME/.config"
backup_and_link "$DOTFILES/tmux" "$HOME/.config/tmux"

# -- Scripts ----------------------------------------------------

printf '\n\033[1m[ Scripts ]\033[0m\n'
mkdir -p "$HOME/.local/bin"

for script in "$DOTFILES"/scripts/*; do
    [ -f "$script" ] || continue
    name="$(basename "$script")"

    # Make executable
    if chmod +x "$script" 2>/dev/null; then
        ok "chmod +x scripts/$name"
    else
        warn "Could not chmod +x scripts/$name - skipping"
        continue
    fi

    backup_and_link "$script" "$HOME/.local/bin/$name"
done

# -- TPM (Tmux Plugin Manager) ----------------------------------

printf '\n\033[1m[ TPM ]\033[0m\n'
TPM_DIR="$HOME/.tmux/plugins/tpm"

if [ -d "$TPM_DIR" ]; then
    ok "TPM already installed at $TPM_DIR"
else
    info "Cloning TPM…"
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    ok "TPM installed at $TPM_DIR"
fi

# -- Done -------------------------------------------------------

printf '\n\033[1;32m-- Installation complete --\033[0m\n\n'
echo "Next steps:"
echo "  1. Restart your shell or run:  source ~/.zshrc"
echo "  2. Open tmux and type  <prefix> + I  to install plugins"
echo "     (prefix is Ctrl+Space in this config)"
echo ""
