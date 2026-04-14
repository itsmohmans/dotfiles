#!/usr/bin/env zsh

SSH_AGENT_SOCK="$HOME/.ssh/agent.sock"
export SSH_AUTH_SOCK="$SSH_AGENT_SOCK"

# exit code 2 = agent is unreachable
ssh-add -l &>/dev/null
if [[ $? -eq 2 ]]; then
  rm -f "$SSH_AGENT_SOCK"
  eval "$(ssh-agent -a "$SSH_AGENT_SOCK" -s)" >/dev/null
fi

# exit code 0 = keys are loaded, otherwise we need to add them
if ! ssh-add -l &>/dev/null; then
  ssh-add "$HOME/.ssh/id_rsa"
fi
