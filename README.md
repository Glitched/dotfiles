# Ryan’s Dotfiles

This is still in early stages. The automated scripts are not working currently and I have many configs I need to improve and include. Additionally, this is still untested on a new system, but that will change in the coming months.

## Configs Included

* Neovim (Plugins autoinstalled with Plug)
* Fish (Plugins autoinstalled with fisher)
* Git
* macOS
* iTerm Profiles
* Brew Packages (and apps with cask)
* Yabai
* Skhd (For Yabai)
* Karabiner-Elements
* tmux

The future potentially includes Ranger, Starship, VSCode, Emacs, and Vivaldi support.

## Installation

**Warning:** If you want to give these dotfiles a try, you should first fork this repository, review the code, and remove things you don’t want or need. Don’t blindly use my settings unless you know what that entails. _Use at your own risk!_

1. Use this script to install Homebrew, git, and then clone the repo to the current directory
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Glitched/dotfiles/master/install.sh)"
```
2. Run the installation scripts you want
3. Symlink the configs you want

I aim to improve the installation script to automate parts 2 & 3, but that's not a priority.

### Add custom commands without creating a new fork

If `~/.extra` exists, it will be sourced along with the other files. You can use this to add a few custom commands without the need to fork this entire repository, or to add commands you don’t want to commit to a public repository.

My `~/.extra` looks something like this:

```bash
# Git credentials
# Not in the repository, to prevent people from accidentally committing under my name
GIT_AUTHOR_NAME="Ryan Slama"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
git config --global user.name "$GIT_AUTHOR_NAME"
GIT_AUTHOR_EMAIL="example@example.com"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
git config --global user.email "$GIT_AUTHOR_EMAIL"
```

You could also use `~/.extra` to override settings, functions and aliases from my dotfiles repository. It’s probably better to [fork this repository](https://github.com/Glitched/dotfiles/fork) instead, though.

## Feedback

Suggestions/improvements
[welcome](https://github.com/Glitched/dotfiles/issues)!

## Thanks to…
* [Mathias Bynens](https://mathiasbynens.be/), who provided the base that I built this on
* [Rosco Kalis](https://kalis.me) for his great [tutorials](https://kalis.me/dotfiles-automating-macos-system-configuration/) and [.files](https://github.com/rkalis/dotfiles)
* [Paul Irish](https://kalis.me) for his fish config and [.files](https://github.com/paulirish/dotfiles) 
