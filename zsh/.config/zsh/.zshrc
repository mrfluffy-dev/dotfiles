# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=3000
SAVEHIST=3000
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey -v
source ~/.zsh/spaceship/spaceship.zsh
export PATH=$HOME/.local/bin/genymotion:$HOME/bin:/usr/local/bin:$HOME/.emacs.d/bin:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.cabal/bin:$HOME/.ghcup/bin:$HOME/.stack/bin:$PATH
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export NIX_PATH="$HOME/.nix-defexpr/channels"
export FZF_DEFAULT_COMMAND="rg ~ --files --hidden"
export FZF_DEFAULT_OPTS='--height 30% --reverse'
export FZF_CTRL_R_OPTS='--sort'
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export NIX_PATH="$HOME/.nix-defexpr/"
export TERMINAL="alacritty"
export LIBVIRT_DEFAULT_URI="qemu:///system"
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
autoload -U compinit && compinit -u
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
alias anime="~/repos/ani-cli/ani-cli"
alias hentai="~/repos/and-scripts/fap-cli"
alias manga="manga-cli"
alias yt="~/repos/ytfzf/ytfzf  --thumb-viewer='kitty' -t"
alias cd="z"
alias rm="rip"
alias time="hyperfine"
alias kami="~/Documents/Rust/kami/target/release/kami"
alias calc="cpc"
alias pdf="mupdf"
#home clean up
export EDITOR="lvim" 
export ANDROID_HOME="$XDG_DATA_HOME"/android
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export GOPATH="$XDG_DATA_HOME"/go
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export IPYTHONDIR="${XDG_CONFIG_HOME}/ipython"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME"/jupyter
export LESSHISTFILE="$XDG_CACHE_HOME"/less/history
export NUGET_PACKAGES="$XDG_CACHE_HOME"/NuGetPackages
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/pythonrc"
export KERAS_HOME="${XDG_STATE_HOME}/keras"
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"
export XCOMPOSECACHE="${XDG_CACHE_HOME}"/X11/xcompose
export SSB_HOME="$XDG_DATA_HOME"/zoom
#compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"
export HISTFILE="$XDG_STATE_HOME"/zsh/history
export ZDOTDIR="$HOME"/.config/zsh


#alias mv="mvg -g"
alias cp="xcp"
macchina
[ -f ~/.zsh/.fzf.zsh ] && source ~/.zsh/.fzf.zsh
export PATH=$PATH:/home/mrfluffy/.spicetify
eval "$(zoxide init zsh)"
