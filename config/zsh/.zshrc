autoload -U colors && colors  # load colors
autoload -Uz vcs_info  # git support

stty stop undef  # disable CTRL-S to freeze the terminal

setopt prompt_subst  # prompt expansion
setopt interactive_comments  # allow comments after the command

# completion
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
compinit; _comp_options+=(globdots)  # include hidden files in completion

# load aliases if exist
[ -f "$ZDOTDIR/.zsh_aliases" ] && source "$ZDOTDIR/.zsh_aliases"

# fix navigation keys
bindkey -e
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[[H'	  beginning-of-line
bindkey '^[[4~'   end-of-line
bindkey '^[[P'    delete-char

# command history
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"

# python utils
get_py_version() { python3 --version | sed -E 's/Python\ ([0-9]).([0-9]+).(.*)$/\1.\2/' }
get_venv() { [ -n "$VIRTUAL_ENV" ] && printf "(%s)" "$(get_py_version)" }

_get_prompt() {
	local s="%B%F{blue}%~%b"
	[ -n "${vcs_info_msg_0_}" ] && s+="%F{red}:${vcs_info_msg_0_}"
	local ve="$(get_venv)"
	[ -n "$ve" ] && s+=" %F{magenta}$ve"
	s+=" %F{blue}%B$%b %F{reset_color}"
	printf "%s" "$s"
}

precmd() { vcs_info; PROMPT=$(_get_prompt) }

# git style
zstyle ":vcs_info:*" check-for-changes true
zstyle ":vcs_info:*" unstagedstr " *"
zstyle ":vcs_info:*" stagedstr " +"

zstyle ":vcs_info:git:*" formats "%b%u%c"
zstyle ":vcs_info:git:*" actionformats "%b|%a%u%c"

autoload -U promptinit && promptinit

# load syntax highlighting
[ -d "$ZDOTDIR/fsh" ] && source "$ZDOTDIR/fsh/F-Sy-H.plugin.zsh"
