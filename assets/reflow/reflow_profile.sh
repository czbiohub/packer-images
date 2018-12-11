
## Make tmux Session
tmux -2 new-session -d -s reflow
tmux split-window -h
tmux select-pane -t 0
tmux send-keys "htop" C-m
tmux select-pane -t 1
