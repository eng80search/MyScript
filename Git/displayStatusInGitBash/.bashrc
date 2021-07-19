export LANG=ja_JP.UTF-8

# PS1="\[\033[01;35m\][\u@Git \t]\[\033[00m\] \[\033[01;33m\]\w\[\033[00m\]\[\033[00;36m\]`__git_ps1`\[\033[00m\]\\n\$ "
# PS1="\[\033[01;35m\][\u@Git \t]\[\033[00m\] \[\033[01;33m\]\w\[\033[00m\]\[\033[00;36m\]$(__git_ps1)\[\033[00m\]\\n\$ "

# PS1="\[\033]0;$TITLEPREFIX:$PWD\007\]\n\[\033[32m\]\u@\h \[\033[35m\]$MSYSTEM \[\033[33m\]\w\[\033[36m\]`__git_ps1`\[\033[0m\]\n$ "

#
# git-completion.bash / git-prompt.sh
#
# if [ -f ~/git-completion.bash ]; then
#     source ~/git-completion.bash
# fi
# if [ -f ~/git-prompt.sh ]; then
#     source ~/git-prompt.sh
# fi
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto
