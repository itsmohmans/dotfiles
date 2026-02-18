# ~/.dotfiles/zsh/aliases.zsh
# All shell aliases, grouped by category.

# -- Core overrides ----------------------------------------------
alias cat="bat"
alias ls="eza -h --git"
alias lls='eza -h1lF --no-user --git'
alias please="sudo"

# -- Clipboard --------------------------------------------------
alias clip='xclip -i -selection clipboard'

# -- Shell management -------------------------------------------
alias rezsh='source ~/.zshrc'
alias zshedit="nano ~/.zshrc"

# -- VS Code ----------------------------------------------------
alias code="/usr/bin/code --password-store=basic"

# -- Git --------------------------------------------------------
alias commit='git commit -m'
alias clone='git clone'
alias ghpr="gh pr create --base development --assignee itsmohmans"

# -- Commitizen -------------------------------------------------
alias cz='cz commit'

# -- Tmux -------------------------------------------------------
alias remux='tmux source ~/.config/tmux/tmux.conf'

# -- LAMPP / PHP ------------------------------------------------
alias phpstart="sudo /opt/lampp/lampp startapache"
alias phpstop="sudo /opt/lampp/lampp stopapache"

# -- Office -----------------------------------------------------
alias onlyoffice="onlyoffice-desktopeditors"
alias office="onlyoffice-desktopeditors"

# -- CLI tools --------------------------------------------------
alias glow='glow -p'

# -- Monitoring -------------------------------------------------
alias fanspeed="watch -n 1 'sensors | grep fan1'"

# -- Conda / Orange3 --------------------------------------------
alias orange3='conda activate orange3 && orange-canvas'

# -- Rclone (use with -P or -i) ---------------------------------
alias uniup='rclone sync --create-empty-src-dirs ~/Documents/uni/ uniDrive:uni/'
alias unidown='rclone sync --create-empty-src-dirs uniDrive:uni/ ~/Documents/uni/'
alias courseup='rclone sync --create-empty-src-dirs ~/Documents/uni/courses uniDrive:uni/courses'
alias coursedown='rclone sync --create-empty-src-dirs uniDrive:uni/courses ~/Documents/uni/courses'

# -- Spotify TUI ------------------------------------------------
alias spt="$HOME/scripts/run_spt.sh"

# -- Misc -------------------------------------------------------
alias dokcer="echo 'You spelled it wrong, dumbass! Go easy on the keyboard.'"
