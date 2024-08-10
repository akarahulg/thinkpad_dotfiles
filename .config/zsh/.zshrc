# Luke's config for the Zoomer Shell

# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
# Load vcs_info
autoload -Uz vcs_info

# Run vcs_info before displaying the prompt
precmd() { vcs_info }

# Enable vcs_info for Git and configure the format
zstyle ':vcs_info:git:*' formats 'on %b'
zstyle ':vcs_info:*' enable git

# Enable prompt substitution
setopt PROMPT_SUBST

# Set the prompt to include vcs_info
PROMPT='%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[cyan]%} ${vcs_info_msg_0_}%{$fg[red]%}]
 %*%{$reset_color%}$%b '


setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY      # Share history between sessions
setopt HIST_IGNORE_DUPS   # Ignore duplicate commands in history
setopt HIST_IGNORE_SPACE  # Ignore commands that start with a space
setopt HIST_FIND_NO_DUPS  # Do not display duplicates in history search

# Load aliases and shortcuts if existent.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp -uq)"
    trap 'rm -f $tmp >/dev/null 2>&1 && trap - HUP INT QUIT TERM PWR EXIT' HUP INT QUIT TERM PWR EXIT
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' '^ulfcd\n'

bindkey -s '^a' '^ubc -lq\n'

bindkey -s '^f' '^ucd "$(dirname "$(fzf)")"\n'

bindkey '^[[P' delete-char

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[P' vi-delete


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/rahul/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/rahul/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/rahul/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/rahul/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


#CUSTOM exports
export PATH=$PATH:/home/rahul/fv5.5.2

export PATH=$PATH:/home/rahul/TESTING/suitPipeline
export al1suit=/home/rahul/TESTING/suitPipeline/bash_scripts
export suitproduct=/home/rahul/data2/suitproducts
export qldinfolder=/home/rahul/data2/suitproducts/archive
export suitdata=/home/rahul/data2/suit_data

#export suitspice=/home/rahul/Downloads/SPICE/kernels
export suitspice="/home/rahul/TESTING/SPICE/kernels"

export limboutfolder=$suitproduct/limbfit
export limblatestimgfolder=$suitproduct/limbfitimg
export PATH=$PATH:/home/rahul/.local/bin
export PATH=$PATH:/home/rahul/git/usefulscripts

export logo1=$al1suit/../suit_white.png
export logo2=$al1suit/../sun_iucaa.png
export logo3=$al1suit/../iucaaisro.png

export shareddir=/srv/http/shareddir
alias keyadd='eval $(ssh-agent -s);ssh-add  ~/.ssh/suit226'



# Load plugins
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh 2>/dev/null



#heasoft
export CC=/usr/bin/gcc
export CXX=/usr/bin/g++
export FC=/usr/bin/gfortran
export PERL=/usr/bin/perl
export PYTHON=/usr/bin/python3

#export HEADAS=/home/rahul/packages/heasoft/heasoft-6.33.2/x86_64-pc-linux-gnu-libc2.40/
#source $HEADAS/headas-init.sh
