# ---------------------------------------------------------------
# ~/.zshrc
# Dotfiles location: $HOME/dotfiles/zsh/
# ---------------------------------------------------------------

# do nothing for non-interactive shells
[[ $- != *i* ]] && return

# -- Oh My Zsh --------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="amuse"
plugins=(git z)
source "$ZSH/oh-my-zsh.sh"

# -- Modules config directory -----------------------------------
ZSH_MODULES="$HOME/dotfiles/zsh"

# Source a file only if it exists
_source_if_exists() { [[ -f "$1" ]] && source "$1"; }

# Core modules
_source_if_exists "$ZSH_MODULES/exports.zsh"
_source_if_exists "$ZSH_MODULES/path.zsh"
_source_if_exists "$ZSH_MODULES/aliases.zsh"
_source_if_exists "$ZSH_MODULES/functions.zsh"

# Tool-specific initializations
# for toolfile in "$ZSH_MODULES"/tools/*.zsh; do
#     _source_if_exists "$toolfile"
# done
# unset toolfile
