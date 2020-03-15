if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

starship init fish | source

alias vi="nvim"
alias gs="git status --short"
alias ...="cd ../../"
alias ....="cd ../../../"

fish_vi_key_bindings

# opam configuration
source /Users/ryan/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
