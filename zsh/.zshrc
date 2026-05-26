# -----------------------------
# Fast .zshrc
# -----------------------------

[[ $- != *i* ]] && return

# History
HISTSIZE=5000
HISTFILE="$HOME/.zsh_history"
SAVEHIST=$HISTSIZE
setopt APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_ALL_DUPS

# Keybinds
bindkey -e
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Paths
export PATH="$HOME/.local/bin:$PATH"
export BUN_INSTALL="$HOME/.local/share/reflex/bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.local/share/gem/ruby/3.4.0/bin:$PATH"
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
export PATH="$HOME/.opencode/bin:$PATH"

# BAT
export BAT_THEME="base16"
alias bat='bat --paging=never'

# FZF colors only
export FZF_DEFAULT_OPTS="
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8
--color=selected-bg:#45475A
--color=border:#313244,label:#CDD6F4"
export FZF_TAB_COLORS='fg:#CDD6F4,bg:#1E1E2E,hl:#F38BA8,min-height=5'

# Zinit
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "$ZINIT_HOME/zinit.zsh"

# Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab

# Completion cache
autoload -Uz compinit
mkdir -p "$HOME/.cache/zsh"
compinit -d "$HOME/.cache/zsh/zcompdump-$ZSH_VERSION"
zinit cdreplay -q

# Completion styling
zstyle ':completion:*' matcher-list 'm:{A-Za-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' fzf-flags --height=17
zstyle ':fzf-tab:complete:*' fzf-preview '
if [ -d "$realpath" ]; then
  eza --icons --tree --level=2 --color=always "$realpath"
elif [ -f "$realpath" ]; then
  bat -n --color=always --line-range :500 "$realpath"
fi
'

# Aliases
alias ls='eza --icons --color=always'
alias ll='eza --icons --color=always -l'
alias la='eza --icons --color=always -a'
alias lla='eza --icons --color=always -la'
alias lt='eza --icons --color=always -a --tree --level=1'
alias grep='grep --color=always'
alias vim='nvim'
alias cbonsai='cbonsai -l -i -w 1'
alias pn='pnpm'

# zoxide
eval "$(zoxide init zsh)"

# starship
eval "$(starship init zsh)"

# Dart completion
[[ -f "$HOME/.dart-cli-completion/zsh-config.zsh" ]] && source "$HOME/.dart-cli-completion/zsh-config.zsh"

# Bun completion
[[ -s "$HOME/.local/share/reflex/bun/_bun" ]] && source "$HOME/.local/share/reflex/bun/_bun"

# yazi
function y() {
  local tmp cwd
  tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# -----------------------------
# Lazy-load nvm
# -----------------------------
export NVM_DIR="$HOME/.nvm"

_lazy_load_nvm() {
  unset -f nvm node npm npx
  [[ -s /usr/share/nvm/init-nvm.sh ]] && source /usr/share/nvm/init-nvm.sh
}

nvm()  { _lazy_load_nvm; nvm "$@"; }
node() { _lazy_load_nvm; node "$@"; }
npm()  { _lazy_load_nvm; npm "$@"; }
npx()  { _lazy_load_nvm; npx "$@"; }

# -----------------------------
# Lazy-load rbenv
# -----------------------------
_lazy_load_rbenv() {
  unset -f rbenv ruby gem bundle irb
  eval "$(rbenv init - zsh)"
}

rbenv()  { _lazy_load_rbenv; rbenv "$@"; }
ruby()   { _lazy_load_rbenv; ruby "$@"; }
gem()    { _lazy_load_rbenv; gem "$@"; }
bundle() { _lazy_load_rbenv; bundle "$@"; }
irb()    { _lazy_load_rbenv; irb "$@"; }

# Cortex CLI completion (disable via /settings in cortex)
[[ -s ~/.zsh/completions/cortex.zsh ]] && source ~/.zsh/completions/cortex.zsh
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
export PATH=$JAVA_HOME/bin:$PATH
echo -e "\e[5 q"


# Added by Antigravity CLI installer
export PATH="/home/mondolreal/.local/bin:$PATH"
