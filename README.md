# Ryan’s dotfiles

This is still in early stages. The automated scripts are not working currently and I have many configs I need to improve and include. Additionally, this is still untested on a new system, but that will change in the coming months.

## Configs Included

* Neovim (Plugins autoinstalled with Plug)
* Fish (Plugins autoinstalled with fisher)
* Git
* macOS
* iTerm Profiles
* Brew Packages (and apps with cask)

## What Will Be Included

* Yabai
* Skhd
* Karabiner-Elements
* Ranger
* Coc Language Support for Neovim
* Starship
The future potentially includes VSCode, Emacs, and Vivaldi support.

## Installation

**Warning:** If you want to give these dotfiles a try, you should first fork this repository, review the code, and remove things you don’t want or need. Don’t blindly use my settings unless you know what that entails. _Use at your own risk!_

I'll be automating this soon, but that's not the priority at the moment.

1. Install homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```
2. Install git `brew install git`
3. Clone this repository.
4. Run the installation scripts you want
5. Symlink the configs you want

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

## Author

[Ryan Slama](https://RyanSlama.com)

## Thanks to…
* [Mathias Bynens](https://mathiasbynens.be/), who provided the base that I built this on
* [Rosco Kalis](https://kalis.me) for his great [tutorials](https://kalis.me/dotfiles-automating-macos-system-configuration/) and [.files](https://github.com/rkalis/dotfiles)
* [Paul Irish](https://kalis.me) for his fish config and [.files](https://github.com/paulirish/dotfiles) 

Inherited from Mathias:
* @ptb and [his _macOS Setup_ repository](https://github.com/ptb/mac-setup)
* [Ben Alman](http://benalman.com/) and his [dotfiles repository](https://github.com/cowboy/dotfiles)
* [Cătălin Mariș](https://github.com/alrra) and his [dotfiles repository](https://github.com/alrra/dotfiles)
* [Gianni Chiappetta](https://butt.zone/) for sharing his [amazing collection of dotfiles](https://github.com/gf3/dotfiles)
* [Jan Moesen](http://jan.moesen.nu/) and his [ancient `.bash_profile`](https://gist.github.com/1156154) + [shiny _tilde_ repository](https://github.com/janmoesen/tilde)
* [Lauri ‘Lri’ Ranta](http://lri.me/) for sharing [loads of hidden preferences](http://osxnotes.net/defaults.html)
* [Matijs Brinkhuis](https://matijs.brinkhu.is/) and his [dotfiles repository](https://github.com/matijs/dotfiles)
* [Nicolas Gallagher](http://nicolasgallagher.com/) and his [dotfiles repository](https://github.com/necolas/dotfiles)
* [Sindre Sorhus](https://sindresorhus.com/)
* [Tom Ryder](https://sanctum.geek.nz/) and his [dotfiles repository](https://sanctum.geek.nz/cgit/dotfiles.git/about)
* [Kevin Suttle](http://kevinsuttle.com/) and his [dotfiles repository](https://github.com/kevinSuttle/dotfiles) and [macOS-Defaults project](https://github.com/kevinSuttle/macOS-Defaults), which aims to provide better documentation for [`~/.macos`](https://mths.be/macos)
* [Haralan Dobrev](https://hkdobrev.com/)
* Anyone who [contributed a patch](https://github.com/mathiasbynens/dotfiles/contributors) or [made a helpful suggestion](https://github.com/mathiasbynens/dotfiles/issues)
