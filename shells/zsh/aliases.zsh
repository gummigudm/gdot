# Listing Aliases
#alias ll='ls -al'
alias ll='ls -alphb --color=auto'

## Directory Aliases
alias cd.='cd ..'
alias cd..='cd ../..'
alias cd...='cd ../../..'
alias cd....='cd ../../../..'
alias cd.....='cd ../../../../..'

## Flush DNS Cache
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

## Copy current directory to clipboard
alias cpc='pwd | pbcopy'
alias cdc='cd "$(pbpaste)"'
