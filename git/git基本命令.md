[toc]

![git-repo](https://www.liaoxuefeng.com/files/attachments/919020037470528/0)

![git-br-dev-fd](https://www.liaoxuefeng.com/files/attachments/919022387118368/0)

### 配置git

* 配置文件：用户家目录下 .gitconfig

  ```shell
  git config --global user.name "Your Name"
  git config --global user.email "email@example.com"
  #让git status正确显示
  git config --global core.quotepath off
  ```

* 设置代理

  * 设置HTTP代理

    ```shell
    #git设置HTTP代理，适用于HTTP协议下载
    git config --global http.proxy "http://127.0.0.1:8080"
    git config --global https.proxy "http://127.0.0.1:8080"
    #取消
    git config --global --unset http.proxy
    git config --global --unset https.proxy
    ```

  * 设置ssh代理

    ```shell
    #git设置ssh代理(方便)
    #修改 ~/.ssh/config 文件（不存在则新建）
    Host github.com
       HostName github.com
       User git
       # 走 HTTP 代理
       # ProxyCommand socat - PROXY:127.0.0.1:%h:%p,proxyport=8080
       # 走 socks5 代理（推荐）
       # ProxyCommand nc -v -x 127.0.0.1:1080 %h %p
    ```

### 创建(create)

* 从一个已存在的仓库克隆

  ```shell
  git clone ssh://user@domain.com/repo.git
  ```

* 创建一个新的本地仓库

  ```shell
  git init
  ```

### 本地变更(local changes)

* 工作目录下changed files

  ```shell
  git status
  ```

* 跟踪文件changes

  ```shell
  git diff <files>
  ```

* 把文件添加进暂存区(stage)

  ```shell
  git add <file>
  ```

* 把文件从暂存区提交到分支

  ```shell
  git commit -m <message>
  ```

### commit历史记录(commit history)

* 显示所有的commit

  ```shell
  #包含commit id、author、email、date、修改说明
  git log
  #显示commit id、修改说明
  git log --pretty=oneline
  ```

* 显示所有分支的所有操作(包括被删除的commit)

  ```shell
  git reflog
  ```

### 撤销(undo)

* 设置当前版本

  ```shell
  #commit可以是HEAD(当前版本)、HEAD^(上一版本)、HEAD^^(上一版本)、HEAD~n(上n个版本)、#commit id
  #撤销commit，不撤销add，不删除工作区改动
  git reset --soft <commit>
  #撤销commit，撤销add，不删除工作区改动
  git reset --mixed <commit>
  #撤销commit，撤销add，删除工作区改动
  git reset --hard <commit>
  ```

* 用版本库的版本替换工作区的版本

  ```shell
  git checkout -- <file>
  ```

### 分支管理(branch)

master是主分支，dev是开发分支，feature分支是具体功能开发分支，只与dev分支交互

* 现场

  ```shell
  #保存现场
  git stash
  #查看现场
  git stash list
  #恢复现场
  git stash apply
  #删除现场
  git stash drop
  #恢复并删除现场
  git stash pop
  ```

* 查看当前所有分支

  ```shell
  git branch
  ```

* 创建分支、切换分支

  ```shell
  #创建dev分支
  git branch <name>
  #切换到dev分支
  git checkout <name>
  git switch <name>
  #创建并切换到dev分支
  git checkout -b <name>
  git switch -c <name>
  ```

* 删除分支

  ```shell
  #删除已合并的分支
  git branch -d <name>
  #删除未合并的分支
  git branch -D <name>
  ```

* 合并分支

  ```shell
  #将当前分支合并到master分支
  git merge <name>
  #禁用Fast forward，使用普通合并
  git merge --no-ff
  ```
  
* Rebase

  ```shell
  #合并多个commit
  git rebase -i <commit>
  #变更基准,使提交看起来是一条直线,没有分叉
  git checkout dev
  git rebase master
  #解决冲突后,结果是dev的开发就像是在master最新的提交上进行的
  ```


### 远程仓库

* 创建SSH Key(如果~/.ssh下有id_rsa和id_rsa.pub，则无需)

  ```shell
  ssh-keygen -t rsa -C "youremail@example.com"
  #一路回车，在.ssh目录下将生成id_rsa(私钥，不能泄露)和id_rsa.pub(公钥)
  ```

* 在github上添加SSH key(id_rsa.pub)

* 关联远程库

  ```shell
  #远程库的别名origin(默认，可修改)
  git remote add origin git@server-name:path/repo-name.git
  ```

* 推送到远程库

  ```shell
  #第一次加-u，可以将本地master分支与远程master分支关联起来
  git push -u origin master
  #之后
  git push origin master
  #推送其他分支
  git push origin <branch name>
  ```
  
* 从远程抓取分支

  ```shell
  #建立本地分支与远程分支的关联
  git branch --set-upstream branch-name origin/branch-name
  #抓取分支
  git pull
  ```

* 查看远程仓库信息

  ```shell
  #查看有哪些远程仓库
  git remote
  #查看具体信息
  git remote -v
  ```

### 标签管理

* 创建标签

  ```shell
  git tag <tagname> (commit id)
  ```

* 查看所有标签

  ```shell
  git tag
  ```

* 显示标签详细信息

  ```shell
  git show <tagname>
  ```

* 指定标签信息

  ```shell
  git tag -a <tagname> -m <message>
  ```

* 删除标签

  ```shell
  #删除本地标签
  git tag -d <tagname>
  #删除远程标签
  git push origin :refs/tags/<tagname>
  ```

* 推送标签到远程

  ```shell
  #推送<tagname>
  git push origin <tagname>
  #推送全部
  git push origin --tags
  ```

> 误传大文件到远程仓库，导致.git文件巨大，解决方案：[见知乎](https://www.zhihu.com/question/29769130/answer/315745139)

