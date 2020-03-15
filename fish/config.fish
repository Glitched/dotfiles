# Autoinstall fisher as a package manager
# and install packages
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

# Starship is a super cool prompt
starship init fish | source

# Editing
alias vi="nvim"

# Git
alias g="git"
alias gs="git status --short"

# Quick directory navigation
alias ...="cd ../../"
alias ....="cd ../../../"
alias .....="cd ../../../../"

# Vi for all the things
fish_vi_key_bindings

# opam configuration
source ~/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

