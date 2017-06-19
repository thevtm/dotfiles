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

# Fasd
eval "$(fasd --init auto)"
alias v='f -e vim'

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# Local config
[[ -f ~/.local/.zshrc ]] && source ~/.local/.zshrc

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# apex
_apex()  {
  COMPREPLY=()
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local opts="$(apex autocomplete -- ${COMP_WORDS[@]:1})"
  COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
  return 0
}

compdef _apex apex

