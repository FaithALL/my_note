# zsh配置, 参考https://github.com/skywind3000/vim/blob/master/etc/zshrc.zsh
# MacPath: ${HOME}/.zshrc
# LinuxPath: ${HOME}/.zshrc

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# 命令行提示符
setopt PROMPT_SUBST
function parse_git_info() {
    local branch_name_color=$'%F{yellow}'
    local branch_name="$(git symbolic-ref --short HEAD 2> /dev/null)"
    if [ -n "$branch_name" ]; then
        printf "%s%s " "${branch_name_color}" "$branch_name"
    fi
}
PROMPT='%B%F{blue}%~ $(parse_git_info)%f%b'

# 小写字母也可以匹配大写字母
# https://superuser.com/questions/1092033/how-can-i-make-zsh-tab-completion-fix-capitalization-errors-for-directories-and
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# 使用emacs风格的键绑定
bindkey -e

# 别名
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# 命令历史记录
HISTFILE=~/.zsh_history
SAVEHIST=4096                   # 存储在文件的命令数
HISTSIZE=4096                   # 加载到内存的命令数
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
    fi
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

# 设置默认编辑器
export EDITOR=nvim

# 本地配置
source ~/.special.zsh

# fzf
if [ -x "$(which fzf)" ]; then
    # mac: brew install fzf && $(brew --prefix)/opt/fzf/install
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
    # archlinux: pacman -S fzf
    [ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
    [ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
    # config
    export FZF_DEFAULT_COMMAND='rg --files --hidden --no-ignore\
                                -g "!{.cache,.git,.gradle,Caches,Containers,DerivedData}" \
                                2>/dev/null'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
fi
