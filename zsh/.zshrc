# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=3000
SAVEHIST=3000
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey -v
autoload -U promptinit; promptinit
prompt spaceship
export PATH=$HOME/.local/bin/genymotion:$HOME/bin:/usr/local/bin:$HOME/.emacs.d/bin:$HOME/.local/bin:$HOME/.cargo/bin:$PATH
export XDG_CONFIG_HOME="$HOME/.config"
export FZF_DEFAULT_COMMAND="rg ~ --files --hidden"
export FZF_DEFAULT_OPTS='--height 30% --reverse'
export FZF_CTRL_R_OPTS='--sort'
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export NIX_PATH="$HOME/.nix-defexpr/"
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[N" down-line-or-beginning-search
alias switch="sudo nixos-rebuild switch"
alias nix-edit="sudo vim /etc/nixos/configuration.nix"
alias ls="exa -lag --icons"
alias upload="~/.config/script/upload.sh"
alias vim="nvim"
alias cat="bat"
alias anime="~/repos/ani-cli/ani-cli -q '720'"
alias hentai="~/repos/and-scripts/fap-cli"
alias manga="manga-cli"
alias yt="~/repos/ytfzf/ytfzf  --thumb-viewer='kitty' -t"
alias cd="z"
#alias mv="mvg -g"
alias cp="xcp"
neofetch
[ -f ~/.zsh/.fzf.zsh ] && source ~/.zsh/.fzf.zsh
export PATH=$PATH:/home/mrfluffy/.spicetify
eval "$(zoxide init zsh)"
