if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"


plugins=(git)

source $ZSH/oh-my-zsh.sh


source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

export LS_COLORS="di=38;5;213:fi=38;5;159:ln=38;5;198:pi=38;5;202:so=38;5;160:bd=38;5;226:cd=38;5;51:ex=38;5;82"
alias ls='ls --color=auto'

fastfetch -l "Linux-generic"
eval "$(starship init zsh)"
alias ls='lsd -hA'
alias tree='eza -T --icons'
alias rm='rm -i'

weather=$(curl -s --max-time 2 "https://wttr.in/Kandy?format=%C+%t")
echo "🛰️ Pilot Dulsara, atmospheric scan: $weather"
echo "⚡ All systems nominal, ready for launch."
