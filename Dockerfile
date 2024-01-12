# 使用 Node.js 20 版本作为基础镜像
FROM node:20

# 设置非交互式前端，防止在安装过程中出现交互式提示
ARG DEBIAN_FRONTEND=noninteractive

# 设置环境变量，如果没有特别需要则不配置 BING_HEADER
ENV BING_HEADER ""
ENV HOME=/home/user
ENV PATH=/home/user/.local/bin:$PATH

# 创建新用户 "user"，用户 ID 为 1000，并设置工作目录
RUN useradd -o -u 1000 user && mkdir -p $HOME/app && chown -R user $HOME

# 切换到 "user" 用户
USER user

# 设置工作目录为用户的 home 目录下的 app 文件夹
WORKDIR $HOME/app

# 将当前目录内容复制到容器中的 $HOME/app，并设置所有者为 user
COPY --chown=user . $HOME/app/

# 如果 ".next/routes-manifest.json" 文件不存在，则执行 npm install 和 npm run build
RUN if [ ! -f ".next/routes-manifest.json" ]; then \
  npm install && npm run build; \
  fi

# 删除 src 目录
RUN rm -rf src

# 设置环境变量 PORT 为 7860
ENV PORT 7860

# 暴露端口 7860
EXPOSE 7860

# 容器启动时执行 npm start
CMD ["npm", "start"]
