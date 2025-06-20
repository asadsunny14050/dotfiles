# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
#void for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Setup fzf keybindings and fuzzy completion
# eval "$(fzf --bash)"

alias gohome="cd ~"
alias gobase="cd ~/coding"
alias gobashconfig="nvim ~/.bashrc"
alias gotmuxconfig="nvim ~/.tmux.conf"
alias gonvimconfig="cd ~/.config/nvim"
alias ls=eza 
alias fd=fdfind
alias peek=peekaboo
alias cat=batcat
alias inv='nvim $(fzf --preview="batcat --color=always {}")'
alias vim=nvim
alias vi=nvim
alias v=nvim
alias fman="compgen -c | fzf | xargs man"

export FZF_DEFAULT_COMMAND='rg --files --hidden --no-ignore-vcs --glob "!{node_modules/*,.git/*}"'
export PATH="/usr/local/bin:$PATH"

df() {
    local dir
    # dir=$(find ${1:-.} -type d -name node_modules -prune -o -type d -print 2> /dev/null | fzf --height 50% --preview 'eza -l --color=always {}') && cd "$dir"
     dir=$( (fdfind --type d --max-depth 1 .; \
            fdfind --type d --exclude node_modules .) \
            | fzf --height 50% --preview 'eza -l --color=always {}')

    [ -n "$dir" ] && cd "$dir"
}


# Fuzzy search relative to your base folder (e.g., coding-folder)
cdf() {
  local dir session
  dir=$(
    (
      fdfind --type d --max-depth 1 . ~/coding;
      fdfind --type d --exclude node_modules . ~/coding
    ) | fzf --preview 'eza -l --color=always {}'
  )

  [ -z "$dir" ] && return  # exit if nothing selected

  cd "$dir" || return

  # Get the directory name for session naming
  session=$(basename "$dir")

  # If not in tmux, launch a new tmux session
  if [ -z "$TMUX" ]; then
    if tmux has-session -t "$session" 2>/dev/null; then
      tmux attach-session -t "$session"
    else
      tmux new-session -s "$session"
    fi
  else
    # If already inside tmux, create or switch to session in a new window
    if tmux has-session -t "$session" 2>/dev/null; then
      tmux switch-client -t "$session"
    else
      tmux new-session -ds "$session"
      tmux switch-client -t "$session"
    fi
  fi
}




function vdf() {
     # dir=$(find ~/coding -type d -name node_modules -prune -o -type d -print 2> /dev/null | fzf  --preview 'eza -l --color=always {}') && cd "$dir" && nvim . 
     # using fd
      dir=$( (find ~/coding -maxdepth 1 -type d -print; \
            find ~/coding -mindepth 2 -type d -name node_modules -prune -o -type d -print) \
            2> /dev/null | fzf --preview 'eza -l --color=always {}')

    [ -n "$dir" ] && cd "$dir" && nvim .
}

eval "$(starship init bash)"


export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export PATH="$PATH:~/coding/c-programming/peekaboo-my-ls"
export PATH="$PATH:~/downloads/"

export NODE_COMPILE_CACHE=~/.cache/nodejs-compile-cache

set -o vi

PS1='\n\u@\h:\w\$ '

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export EDITOR=$(which nvim)
