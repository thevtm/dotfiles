# Configs
export EDITOR='vim'

# Disable XON/XOFF
stty -ixon

# Install zplug if not presente
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi

# Source zplug/zplug
source ~/.zplug/init.zsh

#
# Declare custom theme segments here
# https://github.com/Powerlevel9k/powerlevel9k#custom_command
#
custom::is_git() {
  # See https://git.io/fp8Pa for related discussion
  [[ $(command git rev-parse --is-inside-work-tree 2>/dev/null) == true ]]
}
custom_dir() {
  local 'dir' 'trunc_prefix'
  # Threat repo root as a top-level directory or not
  if custom::is_git; then
    local git_root=$(git rev-parse --show-toplevel)
    dir="$git_root:t${${PWD:A}#$~~git_root}"
  else
    dir="%~"
  fi
  echo "$dir"
}


###########
# PLUGINS #
###########

# oh-my-zsh
export ZSH=$HOME/.zplug/repos/robbyrussell/oh-my-zsh
zplug "plugins/gnu-utils", from:oh-my-zsh
# zplug "plugins/archlinux", from:oh-my-zsh, if:"which pacman"
zplug "plugins/systemd", from:oh-my-zsh, if:"which systemctl"
zplug "plugins/git",   from:oh-my-zsh
zplug "plugins/grep", from:oh-my-zsh
# zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/node", from:oh-my-zsh
zplug "plugins/npm", from:oh-my-zsh
zplug "plugins/yarn", from:oh-my-zsh
# zplug "plugins/rsync", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh
# #zplug "plugins/tmux", from:oh-my-zsh
zplug "plugins/ruby", from:oh-my-zsh
zplug "plugins/rails", from:oh-my-zsh
zplug "plugins/bundler", from:oh-my-zsh


# zsh-user
zplug "zsh-users/zsh-completions", defer:3
zplug "zsh-users/zsh-syntax-highlighting", defer:3
zplug "zsh-users/zsh-autosuggestions", defer:3
zplug "zsh-users/zsh-history-substring-search", defer:2

# fzy
zplug "aperezdc/zsh-fzy"


# theme
POWERLEVEL9K_MODE='awesome-fontconfig'

# POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context ssh custom_dir vcs)
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

# zsh-fzy
# ALT-C: cd into the selected directory
bindkey '\ec' fzy-cd-widget

# CTRL-T: Place the selected file path in the command line
zstyle :fzy:file command rg --files
bindkey '^T'  fzy-file-widget

# CTRL-R: Place the selected command from history in the command line
# bindkey '^R'  fzy-history-widget

# CTRL-P: Place the selected process ID in the command line
bindkey '^P'  fzy-proc-widget

# direnv
eval "$(direnv hook zsh)"

# fzf
source '/usr/share/fzf/key-bindings.zsh'

# Less
export LESS='--RAW-CONTROL-CHARS --LINE-NUMBERS --no-init'

# fasd
eval "$(fasd --init auto)"
alias v='f -e vim'

# thefuck
eval $(thefuck --alias)

# yarn
export PATH="$(yarn global bin):$PATH"

# Encoding stuff for the terminal
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# local bins
export PATH="$HOME/.local/bin:$PATH"

# Local config
[[ -f ~/.local/.zshrc ]] && source ~/.local/.zshrc

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases
[[ -f ~/.local/.aliases ]] && source ~/.local/.aliases

########################################### testing
# Apply changes to keyboard key mapping
# (removed due to it turning on and off randomly)
# xmodmap ~/.Xmodmap
##########################################

#######################################
# Some usefull kubectl commands
#######################################
function kube-find-namespace() {
  kubectl get namespaces | tail -n +2 | fzf -q "$1" | awk '/(.*)/ {print $1}'
}

function kube-app-pod() {
  local namespace
  namespace=$1
  kubectl get pods --field-selector status.phase=Running -n "$namespace" | awk '/(.*)-app-(.*) / {print $1}' | head -n 1
}

function kube-rc() {
  local namespace
  namespace="$(kube-find-namespace "$1")"
  local pod
  pod="$(kube-app-pod "$namespace")"
  echo "Dropping into rails console on $pod in $namespace"
  kubectl exec -it "$pod" -n "$namespace" -- rails c
}

function kube-ssh() {
  local namespace
  namespace="$(kube-find-namespace "$1")"
  local pod
  pod="$(kube-app-pod "$namespace")"
  echo "Dropping into bash on $pod in $namespace"
  kubectl exec -it "$pod" -n "$namespace" bash
}

function kube-log() {
  local namespace
  namespace="$(kube-find-namespace "$1")"
  local pod
  pod="$(kube-app-pod "$namespace")"
  echo "Tailing logs on $pod in $namespace"
  kubectl logs "$pod" -n "$namespace" -f
}

alias kssh="kube-ssh"
alias krc="kube-rc"
alias klog="kube-log"
