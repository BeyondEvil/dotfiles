HISTSIZE=5000
HISTFILE=$ZDOTDIR/.zsh_history
SAVEHIST=5000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PYTHONDONTWRITEBYTECODE=1

eval "$(/opt/homebrew/bin/brew shellenv)"

eval "$(pyenv init -)"

autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit

# case-insensitivity
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# pure prompt
# fpath+=/opt/homebrew/share/zsh/site-functions
# autoload -U promptinit; promptinit
# prompt pure

# AWS CLI completion
complete -C "${HOME}/.local/bin/aws_completer" aws

# source zsh plugins
for plugin in "${ZDOTDIR}"/plugins/*; do
  name=$(basename "${plugin}")
  _source="${plugin}/${name}.zsh"
  [[ -s "${_source} "]] && source "${plugin}/${name}.zsh"
done

fpath+="${ZDOTDIR}"/plugins/zsh-completions/src

eval "$(starship init zsh)"
