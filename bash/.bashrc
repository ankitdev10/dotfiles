# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

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

# some new paths for installed things
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/opt/nvim-linux64/bin"

eval "$(starship init bash)"


# some helpful aliases 
alias tka='tmux kill-server' 
alias tka='tmux kill-server' 
alias cdh='cd ~/hyperce'
alias cdo='cd ~/orgo'
alias cdk='cd ~/koulier'
alias ll='ls -alF --color=auto'
alias cdp='cd ~/personal'
alias koulier-staging='ssh -i ~/.ssh/koulier-staging.pem ubuntu@koulier.ovh'
alias koulier-prod='ssh -i ~/.ssh/koulier-prod.pem ubuntu@79.137.37.106'
alias staging='ssh -i ~/.ssh/staging.pem ubuntu@141.94.126.76'
alias prod='ssh -i ~/.ssh/prod.pem ubuntu@37.59.28.154'
alias lex-prod='ssh -i ~/.ssh/lex.pem ubuntu@91.134.55.26'
alias lex-staging='ssh -i ~/.ssh/lex.pem ubuntu@152.228.215.251'
alias corpsec='ssh -i ~/.ssh/lex.pem ubuntu@135.125.47.212'
alias corpsec-staging='ssh -i ~/.ssh/preview-server.pem ubuntu@137.74.133.159'

alias pcc='CLAUDE_CONFIG_DIR=~/.claude-personal claude'


alias kill-lsp='pkill -f "tsserver|tailwindcss-language-server|eslint-language-server|next-server"'
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
force_color_prompt=yes

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




export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
export ANDROID_HOME="$ANDROID_SDK_ROOT"
export PATH="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator:$PATH"

alias avds='emulator -list-avds'
alias android10='emulator -avd pixel_android_10'
alias android14='emulator -avd pixel34'
alias android-version='adb shell getprop ro.build.version.release && adb shell getprop ro.build.version.sdk'

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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH=$PATH:$(go env GOPATH)/bin

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/ankitey/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/home/ankitey/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/ankitey/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/home/ankitey/Downloads/google-cloud-sdk/completion.bash.inc'; fi

restro-staging() {
  aws ecs execute-command \
    --cluster restronaut-saas-staging \
    --region us-east-2 \
    --task "$(aws ecs list-tasks \
      --cluster restronaut-saas-staging \
      --service-name restronaut-saas-staging-backend-service \
      --desired-status RUNNING \
      --region us-east-2 \
      --query 'taskArns[0]' \
      --output text)" \
    --container backend \
    --command "/bin/sh" \
    --interactive
}

aux() {
    local count="${1:-20}"
    printf "\033[1;37m%-7s  %-40s  %8s  %6s  %6s\033[0m\n" "PID" "NAME" "RAM" "%MEM" "%CPU"
    echo "───────────────────────────────────────────────────────────────────────────"
    ps aux --sort=-%mem | awk -v c="$count" '
    NR>1 && NR<=c+1 {
        rss=$6; mem=$4; cpu=$3; pid=$2

        # Grab full command from $11 onward
        cmd=""
        for(i=11;i<=NF;i++) cmd=cmd (i>11?" ":"") $i

        # Start with binary name
        n=split($11,p,"/"); name=p[n]

        # --- Brave: distinguish tab vs gpu vs extension ---
        if(name=="brave") {
            if(cmd ~ /--type=renderer/) {
                if(cmd ~ /--extension-process/) name="brave (extension)"
                else name="brave (tab)"
            }
            else if(cmd ~ /--type=gpu-process/) name="brave (gpu)"
            else if(cmd ~ /--type=utility/) name="brave (utility)"
            else name="brave (main)"
        }

        # --- Node: find what it is actually running ---
        else if(name=="node") {
            arg=""
            for(i=12;i<=NF;i++) {
                if($i ~ /^-/) continue
                nn=split($i,pp,"/"); arg=pp[nn]
                break
            }
            if(arg != "") name="node: " arg
        }

        # --- Python: same idea ---
        else if(name ~ /^python/) {
            arg=""
            for(i=12;i<=NF;i++) {
                if($i ~ /^-/) continue
                nn=split($i,pp,"/"); arg=pp[nn]
                break
            }
            if(arg != "") name=name ": " arg
        }

        # --- Java ---
        else if(name=="java") {
            for(i=12;i<=NF;i++) {
                if($i ~ /^-/) continue
                nn=split($i,pp,"/"); name="java: " pp[nn]
                break
            }
        }

        # --- next-server ---
        else if(name ~ /^next-server/) {
            name="next-server"
        }

        # --- Claude Code ---
        else if(name=="claude") {
            name="claude-code"
        }

        # Truncate
        if(length(name)>40) name=substr(name,1,37)"..."

        # Human readable RSS
        if(rss>=1048576) r=sprintf("%.1fG",rss/1048576)
        else if(rss>=1024) r=sprintf("%.0fM",rss/1024)
        else r=sprintf("%dK",rss)

        # Color by memory
        if(mem+0>=5) c_="\033[1;31m"
        else if(mem+0>=2) c_="\033[1;33m"
        else c_="\033[0m"

        printf c_"%-7s  %-40s  %8s  %5.1f%%  %5.1f%%\033[0m\n",pid,name,r,mem,cpu
    }'
}

# pnpm
export PNPM_HOME="/home/ankitey/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
. "$HOME/.cargo/env"

[ -f "$HOME/.bashrc.local" ] && . "$HOME/.bashrc.local"

[ -r "$HOME/.config/ls_colors/catppuccin-mocha" ] && export LS_COLORS="$(< "$HOME/.config/ls_colors/catppuccin-mocha")"
bind 'set colored-stats on' 2>/dev/null
bind 'set colored-completion-prefix on' 2>/dev/null

eval "$(zoxide init bash)"

if [[ $- == *i* && -z "${NO_FETCH-}" ]] && command -v fastfetch >/dev/null; then
    if [[ -z "${TMUX-}" || "$(tmux display -p '#{window_panes}' 2>/dev/null)" == 1 ]]; then
        cols=$(tput cols 2>/dev/null || echo 80)
        if (( cols >= 100 )); then
            fastfetch
        elif (( cols >= 70 )); then
            fastfetch --logo pop_small
        else
            fastfetch --logo none
        fi
        unset cols
    fi
fi
