#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto --group-directories-first'
export LESS="-RSMsi"

# http://henrik.nyh.se/2008/12/git-dirty-prompt
# http://www.simplisticcomplexity.com/2008/03/13/show-your-git-branch-name-in-your-prompt/
#   username@Machine ~/dev/dir[master]$   # clean working directory
#   username@Machine ~/dev/dir[master*]$  # dirty working directory

function parse_git_dirty {
  [[ $(git status --porcelain 2> /dev/null | tail -n1) != "" ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}
#export PS1='\u@\h \[\033[1;33m\]\w\[\033[0m\]$(parse_git_branch)$ '

set_prompt () {
    Last_Command=$? # Must come first!
    Blue='\[\e[01;34m\]'
    White='\[\e[01;37m\]'
    Red='\[\e[01;31m\]'
    Green='\[\e[01;32m\]'
    Reset='\[\e[00m\]'
    FancyX='\342\234\227'
    Checkmark='\342\234\223'

    # Add a bright white exit status for the last command
    PS1="$White\$? "
    # If it was successful, print a green check mark. Otherwise, print
    # a red X.
    if [[ $Last_Command == 0 ]]; then
        PS1+="$Green$Checkmark "
    else
        PS1+="$Red$FancyX "
    fi
    # If root, just print the host in red. Otherwise, print the current user
    # and host in green.
    if [[ $EUID == 0 ]]; then
        PS1+="$Red\\h "
    else
        PS1+="$Green\\u@\\h "
    fi
    # Print the working directory and prompt marker in blue, and reset
    # the text color to the default.
    PS1+="$Blue\\w \\\$$(parse_git_branch)$Reset "
}

PROMPT_COMMAND='set_prompt'

shopt -s cdspell                 # Correct cd typos
shopt -s checkwinsize            # Update windows size on command
shopt -s histappend              # Append History instead of overwriting file
shopt -s cmdhist                 # Bash attempts to save all lines of a multiple-line command in the same history entry
shopt -s extglob                 # Extended pattern
shopt -s no_empty_cmd_completion # No empty completion

if [[ -d "$HOME/bin" ]] ; then
  PATH="$HOME/bin:$PATH"
fi

# make multiple shells share the same history file
export HISTSIZE=1000            # bash history will save N commands
export HISTFILESIZE=${HISTSIZE} # bash will remember N commands
export HISTCONTROL=ignoreboth   # ingore duplicates and spaces
export HISTIGNORE='&:ls:ll:la:cd:exit:clear:history'

if which systemctl &>/dev/null; then
  start() {
    sudo systemctl start $1.service
  }
  restart() {
    sudo systemctl restart $1.service
    status $1
  }
  stop() {
    sudo systemctl stop $1.service
  }
  enable() {
    sudo systemctl enable $1.service
  }
  status() {
    sudo systemctl status $1.service
  }
  disable() {
    sudo systemctl disable $1.service
  }
fi

# Pastebin
pb () {
  curl -F "c=@${1:--}" https://ptpb.pw
}

pbx () {
  curl -sF "c=@${1:--}" -w "%{redirect_url}" 'https://ptpb.pw/?r=1' -o /dev/stderr | xsel -l /dev/null -b
}

pbs () {
  asciinema rec /tmp/$$.json
  pbx /tmp/$$.json
}

dirsize () {
  du -shx * .[a-zA-Z0-9_]* 2> /dev/null | egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
  egrep '^ *[0-9.]*M' /tmp/list
  egrep '^ *[0-9.]*G' /tmp/list
  rm -rf /tmp/list
}
