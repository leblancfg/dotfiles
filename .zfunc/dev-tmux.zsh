#!/bin/sh 
tmux new-session -d 'vim'
tmux split-window -h 'ipython'
tmux split-window -v
tmux new-window 'leblancfg'
tmux -2 attach-session -d
