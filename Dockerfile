# 设置基础镜像
FROM ubuntu:14.04

# Get Nodejs
FROM node:5.3.0

# 如果上个步骤已经更新软件源，这步可以忽略
RUN apt-get update

# 安装 NodeJS 和 npm
RUN apt-get install -y nodejs npm

# 将目录中的文件添加至镜像的 /usr/src/app 目录中
ADD . /srv/mosca_server

# 设置工作目录
WORKDIR /srv/mosca_server

# 安装 Node 依赖库
RUN npm install mosca --save
#RUN npm install redis --save
RUN npm install cluster --save



# 暴露 1883 端口，便于访问
EXPOSE 80
EXPOSE 1883

# 设置启动时默认运行命令
CMD ["nodejs", "/srv/mosca_server/index"]
