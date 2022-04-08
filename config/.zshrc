# 参考https://github.com/skywind3000/vim/blob/master/etc/zshrc.zsh

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# 使用256色
export TERM="xterm-256color"

# 命令行提示符
autoload -U colors && colors
PROMPT="%{$fg_bold[green]%}%n@%m%{$reset_color%}:%{$fg_bold[blue]%}%~%{$reset_color%}$ "
# 使用闪烁的|
echo -ne "\e[5;6 q"

# 别名
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'


# 命令历史记录
HISTFILE=~/.bash_history
SAVEHIST=4096                   # 存储在文件的命令数
HISTSIZE=2048                   # 加载到内存的命令数
setopt INC_APPEND_HISTORY       # 立即写入记录文件
setopt HIST_EXPIRE_DUPS_FIRST   # 淘汰记录时,首先淘汰重复记录
setopt HIST_IGNORE_ALL_DUPS     # 如果新记录是重复的,删除老的记录
setopt HIST_IGNORE_DUPS         # 不重复记录相同项
setopt HIST_SAVE_NO_DUPS        # 不保存重复的记录项
setopt HIST_REDUCE_BLANKS       # 记录时删除多余空格


# 插件管理器antigen: https://github.com/zsh-users/antigen
ANTIGEN="$HOME/.local/bin/antigen.zsh"

# 如果不存在antigen,自动下载
if [ ! -f "$ANTIGEN" ]; then
	echo "Installing antigen ..."
	[ ! -d "$HOME/.local" ] && mkdir -p "$HOME/.local" 2> /dev/null
	[ ! -d "$HOME/.local/bin" ] && mkdir -p "$HOME/.local/bin" 2> /dev/null
	# [ ! -f "$HOME/.z" ] && touch "$HOME/.z"
	URL="http://git.io/antigen"
	TMPFILE="/tmp/antigen.zsh"
	if [ -x "$(which curl)" ]; then
		curl -L "$URL" -o "$TMPFILE"
	elif [ -x "$(which wget)" ]; then
		wget "$URL" -O "$TMPFILE"
	else
		echo "ERROR: please install curl or wget before installation !!"
		exit
	fi
	if [ ! $? -eq 0 ]; then
		echo ""
		echo "ERROR: downloading antigen.zsh ($URL) failed !!"
		exit
	fi;
	echo "move $TMPFILE to $ANTIGEN"
	mv "$TMPFILE" "$ANTIGEN"
fi

# 加载antigen
source "$ANTIGEN"

# 使用插件
# 补全提示插件
antigen bundle zsh-users/zsh-autosuggestions
# 语法高亮插件(必须最后一个加载)
antigen bundle zsh-users/zsh-syntax-highlighting

# Tell Antigen that you're done.
antigen apply
