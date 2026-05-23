# ~/.zshrc — managed with zinit + powerlevel10k
# Layout:
#   1. Instant prompt (must stay near the top)
#   2. Environment
#   3. Plugin manager (zinit) + plugins
#   4. Tool integrations (fzf, zoxide, direnv)
#   5. Keybindings & options
#   6. Local overrides

# ---------- 1. p10k instant prompt ----------
# Keep this block first — it lets the prompt render before plugins finish loading.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ---------- 2. Environment ----------
export EDITOR='vim'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LESS='--RAW-CONTROL-CHARS --LINE-NUMBERS --no-init'
export DEFAULT_USER="$USER"

export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Disable XON/XOFF so Ctrl-S / Ctrl-Q are free (interactive shells only)
[[ -o interactive ]] && stty -ixon 2>/dev/null

# ---------- 3. zinit + plugins ----------
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [[ ! -d $ZINIT_HOME ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Theme — load first so instant prompt has its config
zinit ice depth=1
zinit light romkatv/powerlevel10k

# oh-my-zsh snippets (load only what we use, not the whole framework)
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::systemd
zinit snippet OMZP::docker
zinit snippet OMZP::node
zinit snippet OMZP::npm

# zsh-users essentials (deferred = loaded after first prompt)
zinit wait lucid for \
  atinit"zicompinit; zicdreplay" \
    zsh-users/zsh-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
    zsh-users/zsh-completions \
  zsh-users/zsh-history-substring-search

# ---------- 4. Tool integrations ----------
# fzf
[[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -f /usr/share/fzf/completion.zsh   ]] && source /usr/share/fzf/completion.zsh
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# zoxide (replaces fasd) — `z <dir>` to jump, `zi` for interactive
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# direnv
command -v direnv >/dev/null && eval "$(direnv hook zsh)"

# turso
[[ -f "$HOME/.turso/env" ]] && source "$HOME/.turso/env"

# ---------- 5. Options & keybindings ----------
COMPLETION_WAITING_DOTS="true"

# history-substring-search bindings (up/down on partial match)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# ---------- 6. p10k config & local overrides ----------
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

[[ -f ~/.local/.zshrc  ]] && source ~/.local/.zshrc
[[ -f ~/.aliases       ]] && source ~/.aliases
[[ -f ~/.local/.aliases ]] && source ~/.local/.aliases
