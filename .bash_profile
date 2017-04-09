#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export EDITOR=nano

# Some pastebin stuff
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

# Bash completion for beet
#eval "$(beet completion)"
