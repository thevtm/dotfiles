# Special directories
hash -d NdC=~/Documents/numeros-do-cartola

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
zplug "plugins/tmux", from:oh-my-zsh



# zsh-user
zplug "zsh-users/zsh-completions", nice:12
zplug "zsh-users/zsh-syntax-highlighting", nice:12
zplug "zsh-users/zsh-autosuggestions", nice:12
zplug "zsh-users/zsh-history-substring-search", nice:10


# theme
zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load --verbose

# Autocomplete from man pages
#zstyle ':completion:*:manuals'    separate-sections true
#zstyle ':completion:*:manuals.*'  insert-sections   true
#zstyle ':completion:*:man:*'      menu yes select

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

source $ZSH/oh-my-zsh.sh

# Fasd
eval "$(fasd --init auto)"

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
