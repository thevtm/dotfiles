# Configs
export EDITOR=vim

# Disable XON/XOFF
stty -ixon

# Install zplug if not presente
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi

# Source zplug/zplug
source ~/.zplug/init.zsh


###########
# PLUGINS #
###########

# oh-my-zsh
export ZSH=$HOME/.zplug/repos/robbyrussell/oh-my-zsh
zplug "plugins/gnu-utils", from:oh-my-zsh
zplug "plugins/archlinux", from:oh-my-zsh, if:"which pacman"
zplug "plugins/systemd", from:oh-my-zsh, if:"which systemctl"
zplug "plugins/git",   from:oh-my-zsh
zplug "plugins/grep", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/node", from:oh-my-zsh
zplug "plugins/npm", from:oh-my-zsh
zplug "plugins/rsync", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh
#zplug "plugins/tmux", from:oh-my-zsh

# zsh-user
zplug "zsh-users/zsh-completions", defer:3
zplug "zsh-users/zsh-syntax-highlighting", defer:3
zplug "zsh-users/zsh-autosuggestions", defer:3
zplug "zsh-users/zsh-history-substring-search", defer:2

# fzy
zplug "aperezdc/zsh-fzy"

# theme
POWERLEVEL9K_MODE='awesome-fontconfig'

POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)

POWERLEVEL9K_STATUS_VERBOSE=false
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3

export DEFAULT_USER="$USER"

zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load # --verbose

# Autocomplete from man pages
#zstyle ':completion:*:manuals'    separate-sections true
#zstyle ':completion:*:manuals.*'  insert-sections   true
#zstyle ':completion:*:man:*'      menu yes select

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

source $ZSH/oh-my-zsh.sh

# Less
export LESS='--RAW-CONTROL-CHARS --LINE-NUMBERS --no-init'

# trash-cli
alias rm='echo "This is not the command you are looking for. Use trash-put."; false'

# fasd
eval "$(fasd --init auto)"
alias v='f -e vim'

# thefuck
eval $(thefuck --alias)

# direnv
eval "$(direnv hook zsh)"

# exa
alias ls='exa'

# fd
alias find='fd'

# nvm
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# rbenv
export PATH="${HOME}/.rbenv/bin:${PATH}"
type -a rbenv > /dev/null && eval "$(rbenv init -)"

# Encoding stuff for the terminal
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# Local config
[[ -f ~/.local/.zshrc ]] && source ~/.local/.zshrc
