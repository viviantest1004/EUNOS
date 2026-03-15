#!/bin/sh
# EunOS environment setup

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Prompt settings
if [ "$(id -u)" = "0" ]; then
    export PS1="\[\033[1;31m\]root\[\033[0m\]@\[\033[1;36m\]eunos\[\033[0m\]:\[\033[1;34m\]\w\[\033[0m\]# "
else
    export PS1="\[\033[1;32m\]\u\[\033[0m\]@\[\033[1;36m\]eunos\[\033[0m\]:\[\033[1;34m\]\w\[\033[0m\]$ "
fi

# Environment variables
export TERM=xterm-256color
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR=vi
export PAGER=less
export PATH=/usr/local/bin:$PATH

# Aliases
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias open='eunos-open'
alias fm='eunfm'
alias info='eunos-info'
alias calc='eunos-calc'
alias browser='eunos-browser'
alias settings='eunos-settings'
alias net='eunos-net'
alias wifi='eunos-wifi'
alias newfile='eunos-newfile'
alias shutdown='poweroff'
alias restart='reboot'

# Utility functions
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz)  tar xzf "$1" ;;
            *.tar.xz)  tar xJf "$1" ;;
            *.tar)     tar xf "$1"  ;;
            *.bz2)     bunzip2 "$1" ;;
            *.gz)      gunzip "$1"  ;;
            *.zip)     unzip "$1"   ;;
            *.7z)      7z x "$1"    ;;
            *.rar)     unrar x "$1" ;;
            *) echo "Unknown archive format: $1" ;;
        esac
    else
        echo "File not found: $1"
    fi
}

mkcd() {
    mkdir -p "$1" && cd "$1"
}

help() {
    echo ""
    printf "${CYAN}  ╔══════════════════════════════════════════════╗${NC}\n"
    printf "${CYAN}  ║              EunOS Help                      ║${NC}\n"
    printf "${CYAN}  ╚══════════════════════════════════════════════╝${NC}\n"
    echo ""
    printf "${YELLOW}  [ Apps ]${NC}\n"
    printf "  ${GREEN}calc${NC}                  Calculator\n"
    printf "  ${GREEN}browser${NC}               Web browser (lynx/w3m)\n"
    printf "  ${GREEN}fm${NC}                    File manager (TUI)\n"
    printf "  ${GREEN}settings${NC}              System settings\n"
    echo ""
    printf "${YELLOW}  [ Network ]${NC}\n"
    printf "  ${GREEN}net${NC}                   Connect to internet (DHCP)\n"
    printf "  ${GREEN}ping${NC} <host>           Test connection\n"
    printf "  ${GREEN}wget${NC} <url>            Download file\n"
    echo ""
    printf "${YELLOW}  [ System ]${NC}\n"
    printf "  ${GREEN}shutdown${NC}              Shutdown system\n"
    printf "  ${GREEN}restart${NC}               Restart system\n"
    printf "  ${GREEN}info${NC}                  System information\n"
    printf "  ${GREEN}eunos-install${NC} <pkg>   Install package\n"
    echo ""
    printf "${YELLOW}  [ Files ]${NC}\n"
    printf "  ${GREEN}newfile${NC} <name>        Create & edit text file\n"
  printf "  ${GREEN}open${NC} <file>           Auto open file (50+ formats)\n"
    printf "  ${GREEN}extract${NC} <file>        Extract archive\n"
    printf "  ${GREEN}mkcd${NC} <dir>            Create and enter directory\n"
    echo ""
    printf "${YELLOW}  [ Date/Time ]${NC}\n"
    printf "  ${GREEN}eunos-datetime${NC}        Date/time settings\n"
    echo ""
    printf "${YELLOW}  [ Packages ]${NC}\n"
    printf "  ${GREEN}apk add${NC} <pkg>         Install Alpine package\n"
    printf "  ${GREEN}apk search${NC} <query>    Search package\n"
    echo ""
}
