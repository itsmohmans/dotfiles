#!/usr/bin/env zsh

# preferred keys in order
SSH_KEYS=(
  "$HOME/.ssh/id_rsa"
)

# start ssh-agent if SSH_AUTH_SOCK is missing or invalid
if [[ -z "$SSH_AUTH_SOCK" ]] || ! ssh-add -l >/dev/null 2>&1; then
  eval "$(ssh-agent -s)" >/dev/null
fi

# add keys
for key in "${SSH_KEYS[@]}"; do
  if [[ -f "$key" ]]; then
    ssh-add "$key" >/dev/null 2>&1
  fi
done
