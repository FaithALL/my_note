## docker

> [参考1](https://www.cnblogs.com/yahuian/p/13888668.html)、[参考2](https://www.runoob.com/docker/docker-tutorial.html)

* 基本概念：镜像、容器、仓库

* 架构：C/S架构

* 安装

  ```shell
  sudo apt install docker.io
  #让非root用户可以使用
  sudo usermod -aG docker $USER
  ```

* 配置镜像源`/etc/docker/daemon.json`

  ```json
  {
    "registry-mirrors": [
      "https://docker.mirrors.ustc.edu.cn",
      "https://hub-mirror.c.163.com"
    ]
  }
  ```

* 常用命令

  ```shell
  # 基本信息
  docker system df              #查看docker镜像、容器、卷、缓存使用信息
  docker stats                  #查看容器资源使用情况
  
  # image
  docker search NAME            #从仓库搜索相关镜像
  docker pull NAME              #从仓库拉取镜像
  docker image                  #查看image相关选项
  docker image ls -a            #查看镜像
  docker image rm IMAGE         #删除镜像
  docker build -t NAME PATH     #用PATH目录的Dockerfile制作镜像NAME
  
  # container
  docker ps -a                  #查看容器
  docker rm CONTAINER           #删除容器
  docker stop CONTAINER         #关闭容器
  docker start CONTAINER        #启动关闭的容器
  docker restart CONTAINER      #重启容器
  docker attach CONTAINER       #进入容器
  docker cp path CONTAINER:path #复制目录/文件到容器
  docker run --name test -d -p 8080:80 IMAGE
               #指定容器名为test,映射容器80端口到主机8080,后台启动容器
  --privileged                  #使container内的root具有root权限
  --restart=always              #重启docker时，也重启容器
  ```

