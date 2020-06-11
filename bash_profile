source ~/.bashrc

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# eval "$('/c/Anaconda/Scripts/conda.exe' 'shell.bash' 'hook')"
# <<< conda initialize <<<


export PATH="$HOME/.poetry/bin:$PATH"
if [ -e /Users/leblancfg/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/leblancfg/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
