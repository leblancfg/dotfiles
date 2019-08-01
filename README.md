# dotfiles
:briefcase: configuration files for terminal and tools, links directly to ~. Powered by [Dotbot](https://github.com/anishathalye/dotbot).

## Portable configuration files
You could say I'm a *nix user stuck in Windows-land. I use Linux at home, I have a MacBook Pro laptop. ¯\\_(ツ)_/¯

I try to keep my dotfiles *not* tied to a specific OS, and use the venerable [Git-for-Windows](https://gitforwindows.org/) along with tmux for my day-to-day work in Windows. My most used files are:

* `.bashrc`
* `.vimrc`
* `.tmux.conf`

## Installation
Running the command below will create symlinks between the dotfiles in this repo, sitting in your home directory &mdash; where your applications expect them to be!

    # Set up from home folder
    cd && git clone https://github.com/leblancfg/dotfiles && ./dotfiles/install

## Updating dotfiles
As they're symlinks, changing your dotfiles from your home directory will in effect change them in the `dotfiles` repo. To update the repo, simply run:

    # Push updates to dotfiles
    cd ~/dotfiles
    git add .
    git commit -m 'updating dotfiles'
    git push origin master

And conversely, to pull from the repo, run:
    
    # Pull updates from dotfiles
    cd ~/dotfiles
    git pull --ff-only
    ./install -q
