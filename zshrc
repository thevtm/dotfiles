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

# Enable completion for the `zinit` command itself
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Theme — load first so instant prompt has its config
zinit ice depth=1
zinit light romkatv/powerlevel10k

# oh-my-zsh snippets (load only what we use, not the whole framework)
zinit snippet OMZP::git
zinit snippet OMZP::sudo

# Deferred plugins — each loads after first prompt (wait lucid).
# Compinit runs via atload on zsh-completions so its fpath additions are picked up.

zinit ice wait lucid
zinit light Aloxaf/fzf-tab

zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting

zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid blockf atload'zicompinit; zicdreplay'
zinit light zsh-users/zsh-completions

zinit ice wait lucid
zinit light zsh-users/zsh-history-substring-search

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

# History: keep more, share across sessions, skip dupes
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS

# history-substring-search bindings (up/down on partial match)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Home / End (Alacritty + most terminals)
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line

# Delete
bindkey '^[[3~' delete-char

# ---------- 6. p10k config & local overrides ----------
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

[[ -f ~/.local/.zshrc  ]] && source ~/.local/.zshrc
[[ -f ~/.aliases       ]] && source ~/.aliases
[[ -f ~/.local/.aliases ]] && source ~/.local/.aliases
