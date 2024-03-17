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
        printf "%s%s " "$branch_name_color" "$branch_name"
    fi
}
PROMPT='%B%F{blue}%~ $(parse_git_info)%f%b'

# 小写字母也可以匹配大写字母, https://superuser.com/questions/1092033/how-can-i-make-zsh-tab-completion-fix-capitalization-errors-for-directories-and
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# 使用Emacs风格的键绑定
bindkey -e

# 设置别名
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
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
    export FZF_DEFAULT_COMMAND='fd --type file --hidden --follow --no-ignore-vcs'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type directory --hidden'
fi

# download plugin from github, source it
apply_plugin() {
    local all_plugins_dir="$HOME/.zsh_plugins"
    mkdir -p "$all_plugins_dir"

    # check if plugin exists, if not download it
    local plugin_name="$(basename $1)"
    local plugin_dir="$all_plugins_dir/$plugin_name"
    if [ ! -d "$plugin_dir" ]; then
        echo "Downloading $1"
        local plugin_url="https://github.com/$1.git"
        git clone --depth=1 "$plugin_url" "$plugin_dir" > /dev/null 2>&1

        if [ $? -ne 0 ]; then
            echo "ERROR: git clone --depth=1 $plugin_url $plugin_dir failed"
            return
        fi
        echo "Installed $1"
    fi

    local plugin_init="$plugin_dir/$plugin_name.zsh"
    if [ -f "$plugin_init" ]; then
        source "$plugin_init"
    fi
}

apply_plugin zsh-users/zsh-autosuggestions
apply_plugin zsh-users/zsh-syntax-highlighting
