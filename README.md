# dotfiles
:briefcase: configuration files for terminal and tools, links directly to `~`. Powered by [Dotbot](https://github.com/anishathalye/dotbot).

## Portable configuration files
These days, most of my time is spent in MacOs, with my neglected home computer running Linux. My most used files are:

* `.aliases`, that feeds into either
    - `.bashrc` on Linux, or
    - `.zshrc` on MacOS
* `.vimrc`
* `.tmux.conf`

## Installation
Running the command below will create symlinks between the dotfiles in this repo, sitting in your home directory &mdash; where your applications expect them to be!

    # Set up from home folder
    cd && git clone https://github.com/leblancfg/dotfiles && ./dotfiles/install

## Pi

The repository keeps Pi configuration under `pi/` rather than the project-specific `.pi/` path. The
installer links the selected profile to `~/.pi/agent/settings.json` and links each portable skill into
`~/.pi/agent/skills`.

- `pi/agent/settings.json` is the personal profile.
- `pi/agent-work/settings.json` is the work profile. The `USING_DEV` environment variable selects it.
- Public packages from `github.com/leblancfg` appear in both profiles so they load on every machine.
  Work-only packages and extensions belong only in the work profile.

Pi does not support includes in its global settings. The two profiles therefore remain complete,
ordinary settings files. Changes made through `/model` or `/settings` update the selected file through
its symlink and appear as normal Git changes.

## Updating dotfiles
As they're symlinks, changing your dotfiles from your home directory will in effect change them in the `dotfiles` repo. To update the repo, simply run:

    # Push updates to dotfiles
    cd ~/dotfiles
    git add .
    git commit -m 'updating dotfiles'
    git push origin master

Aliases to `dfpush`. And conversely, to pull from the repo, run:
    
    # Pull updates from dotfiles
    cd ~/dotfiles
    git pull --ff-only
    ./install -q

aliased to `dfpull`.
