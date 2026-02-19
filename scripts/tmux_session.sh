SESH="initial_session"

tmux has-session -t $SESH 2>/dev/null

if [ $? != 0 ]; then
  # If the session does not exist, create a new session 
	tmux new-session -d -s $SESH -n "main" -c "/home/$USER"
else
  # If the session exists, create a new window in that session
  tmux new-window -t $SESH -c "/home/$USER"
fi

tmux attach-session -t $SESH

