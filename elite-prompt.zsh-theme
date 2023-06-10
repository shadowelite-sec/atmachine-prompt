#!/bin/sh

# export
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:/opt/metasploit/tools/exploit
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# nvidia
#export __GLX_VENDOR_LIBRARY_NAME=nvidia glxinfo | grep 'OpenGL renderer string'

# alias
alias icat="kitty +kitten icat"
alias ls="ls --color=auto -1"
alias vi="nvim"
alias vim="nvim"
#alias zathura="~/.local/bin/zathura"
alias ip="ifconfig | grep inet | head -n3  | tail -n1"
alias hs="history | cut -c 8- | sort | uniq | fzf | tr -d '\\n' | xclip -selection c"
alias grep="grep --color"
alias pacman="pacman --color auto"
#alias cat="bat"

#shortcuts
gp(){
grep -ir "$1"
}

f(){    
        find $1 -name "$2" 2>/dev/null    
}    
fcd(){    
    
        cd $(find $HOME -type d | fzf)    
    
}    
    
fop(){    
    
        nano $(find $HOME -type f | fzf)    
    
}    

#wal
#(/bin/cat ~/.cache/wal/sequences &)    
#source ~/.cache/wal/colors-tty.sh     

declare -A pomo_options
pomo_options["work"]="45"
pomo_options["break"]="10"

pomodoro () {
  if [ -n "$1" -a -n "${pomo_options["$1"]}" ]; then
  val=$1
  echo $val | lolcat
  timer ${pomo_options["$val"]}m
  spd-say "'$val' session done"
  fi
}

alias wo="pomodoro 'work'"
alias br="pomodoro 'break'"
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

## autoload vcs and colors
autoload -Uz vcs_info
autoload -U colors && colors

# enable only git 
zstyle ':vcs_info:*' enable git 

# setup a hook that runs before every ptompt. 
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst

# add a function to check for untracked files in the directory.
# from https://github.com/zsh-users/zsh/blob/master/Misc/vcs_info-examples
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
# 
+vi-git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        # This will show the marker if there are any untracked files in repo.
        # If instead you want to show the marker only if there are untracked
        # files in $PWD, use:
        #[[ -n $(git ls-files --others --exclude-standard) ]] ; then
        hook_com[staged]+='!' # signify new files with a bang
    fi
}

zstyle ':vcs_info:*' check-for-changes true
# zstyle ':vcs_info:git:*' formats " %r/%S %b %m%u%c "
zstyle ':vcs_info:git:*' formats " %{$fg[blue]%}(%{$fg[red]%}%m%u%c%{$fg[yellow]%}%{$fg[magenta]%} %b%{$fg[blue]%})"
blink=$(tput setaf 6 blink)
end=$(tput sgr0)
banner=$(printf '%s%s%s%s' "$(tput setaf 35)" "$(tput blink)" "S.E" "$(tput sgr0)")
# format our main prompt for hostname current folder, and permissions.
# PROMPT="%B%{$fg[blue]%}[%{$fg[white]%}%n%{$fg[red]%}@%{$fg[white]%}%m%{$fg[blue]%}] %(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )%{$fg[cyan]%}%c%{$reset_color%}"
#PROMPT="%B%{$fg[white]%}┌─[%{$fg[blue]%}%{$fg[white]%}%n%{$fg[red]%}@%{$fg[white]%}%m]%{$fg[blue]%}-%B%{$fg[white]%}[%{$fg[yellow]%}%c%B%{$fg[white]%}]%(?:
#%{$fg[white]%}]
#└─%{$fg[white]%}[%{$blink%}$%{$end%}%{$fg[white]%}]:
#%{$fg[white]%}]
#└─%{$fg[white]%}[%{$blink$fg[red]%}x%{$end%}%{$fg[white]%}])%{$reset_color%}"

#PROMPT="%B%{$fg[white]%}┌─[%{$fg[green]%}%n%{$fg[red]%}@%{$fg[magenta]%}%m%{$fg[white]%}]%{$fg[blue]%}-%B%{$fg[white]%}[%{$fg[yellow]%}%c%B%{$fg[white]%}]%(?:
#└─%{$fg_bold[white]%}[%{$end%}%{$blink%}$%{$end%}%{$fg_bold[white]%}]:
#└─%{$fg_bold[white]%}[%{$blink$fg[red]%}X%{$end%}%{$fg_bold[white]%}])%{$reset_color%}"

# with banner
PROMPT="%B%{$fg[white]%}┌─[%{$fg[green]%}%n%{$fg[red]%}@%{$fg[magenta]%}%m%{$fg[white]%}]%{$fg[blue]%}-%B%{$fg[white]%}[%{$fg[yellow]%}%c%B%{$fg[white]%}] $banner %(?:
└─%{$fg_bold[white]%}[%{$end%}%{$blink%}$%{$end%}%{$fg_bold[white]%}]:
└─%{$fg_bold[white]%}[%{$blink$fg[red]%}X%{$end%}%{$fg_bold[white]%}])%{$reset_color%}"

# PROMPT="%{$fg[green]%}%n@%m %~ %{$reset_color%}%#> "
PROMPT+="\$vcs_info_msg_0_ "
# TODO look into this for more colors
# https://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/
# also ascii escape codes
