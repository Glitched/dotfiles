# Autoinstall fisher as a package manager
# and install packages
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

# Starship is a super cool prompt
starship init fish | source

# Set my Editor
set -gx EDITOR nvim

# Remove fzf's weird selection color
# set -gx FZF_DEFAULT_OPTS "--color bg:-1"
set -gx FZF_DEFAULT_OPTS '
  --color=dark
  --color=fg:-1,bg:-1,hl:#c3e88d,fg+:#ffffff,bg+:-1,hl+:#c792ea
  --color=info:#98c379,prompt:#61afef,pointer:#89ddff,marker:#89ddff,spinner:#61afef,header:#61afef
'

set -gx BAT_THEME 'TwoDark'
# Editing & Files
alias v="nvim"
alias vi="nvim"
alias chmox='chmod +x'

# Replace cat with bat
alias cat=bat

# Recursively delete `.DS_Store` files
alias cleanup_dsstore="find . -name '*.DS_Store' -type f -ls -delete"

# Git
alias git=hub
alias g="git"
alias gs="git status --short"
alias gc="git commit -m"
alias ga="git add"
alias gd="git diff"
alias gca="git commit -am"
alias gp="git push"
alias master="git checkout master"
alias lg="lazygit"

# Vim Accidents
alias :q="exit"
alias :e="nvim"

# Quick directory navigation
alias ...="cd ../../"
alias ....="cd ../../../"
alias .....="cd ../../../../"

# Other shortcuts
alias cask='brew cask'

# Vi all the things
fish_vi_key_bindings

# opam configuration
source ~/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

# Disable greeting
set fish_greeting

# highlighting inside manpages and elsewhere
set -gx LESS_TERMCAP_mb \e'[01;31m'       # begin blinking
set -gx LESS_TERMCAP_md \e'[01;38;5;74m'  # begin bold
set -gx LESS_TERMCAP_me \e'[0m'           # end mode
set -gx LESS_TERMCAP_se \e'[0m'           # end standout-mode
set -gx LESS_TERMCAP_so \e'[38;5;246m'    # begin standout-mode - info box
set -gx LESS_TERMCAP_ue \e'[0m'           # end underline
set -gx LESS_TERMCAP_us \e'[04;38;5;146m' # begin underline

# for things not checked into git..
if test -e "$HOME/.extra.fish";
	source ~/.extra.fish
end

function md --wraps mkdir -d "Create a directory and cd into it"
  command mkdir -p $argv
  if test $status = 0
    switch $argv[(count $argv)]
      case '-*'
      case '*'
        cd $argv[(count $argv)]
        return
    end
  end
end

