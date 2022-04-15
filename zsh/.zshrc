# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=3000
SAVEHIST=3000
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey -v
autoload -U promptinit; promptinit
prompt spaceship
export PATH=$HOME/bin:/usr/local/bin:$HOME/.emacs.d/bin:$HOME/.local/bin:$HOME/.cargo/bin:$PATH
export XDG_CONFIG_HOME="$HOME/.config"
export FZF_DEFAULT_COMMAND="rg ~ --files --hidden"
export FZF_DEFAULT_OPTS='--height 30% --reverse'
export FZF_CTRL_R_OPTS='--sort'
alias ls="exa -lag --icons"
alias vim="nvim"
alias cat="bat"
alias anime="~/repos/ani-cli/ani-cli -q '720'"
alias manga="manga-cli"
alias mv="mvg -g"
alias cp="cpg -g"
neofetch
[ -f ~/.zsh/.fzf.zsh ] && source ~/.zsh/.fzf.zsh
export PATH=$PATH:/home/mrfluffy/.spicetify
