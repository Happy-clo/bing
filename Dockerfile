# 使用 LTS 版本的 Node.js 作为基础镜像
FROM node:20

# 设置非交互式 Debian 前端
ARG DEBIAN_FRONTEND=noninteractive

# 如果没有特别需要不要配置
ENV BING_HEADER ""

# 设置环境变量
ENV HOME=/home/user \
    PATH=/home/user/.local/bin:$PATH \
    PORT=7860

# 创建并设置工作目录
WORKDIR $HOME/app

# 创建一个新用户
RUN useradd -o -u 1000 user && \
    mkdir -p $HOME/app && \
    chown -R user $HOME

# 切换到用户
USER user

# 复制当前目录内容到容器中，设置所有者为用户
COPY --chown=user . $HOME/app/

# 如果 .next/routes-manifest.json 不存在，则执行 npm 安装和构建
RUN [ ! -f ".next/routes-manifest.json" ] && npm install && npm run build || true

# 删除 src 目录
RUN rm -rf src

# 清理 npm 缓存
RUN npm cache clean --force

EXPOSE 7860

# 启动命令
CMD ["npm", "start"]
