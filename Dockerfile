# 使用官方Python基础镜像
FROM python:3.9-buster

# 设置工作目录
WORKDIR /app

# 复制当前目录内容到工作目录
COPY . .

# 修改debian源
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list

# 更新apt-get
RUN apt-get update

# 安装中文字体
RUN apt-get install -y ttf-wqy-microhei

# 安装playwright需要的依赖包
RUN apt-get install -y libnss3 libx11-xcb1 libasound2 libatk-bridge2.0-0 libgtk-3-0 libxcomposite1 libxdamage1 libxfixes3 libxrandr2 libgbm1 libpango-1.0-0 libcairo2 libxkbcommon0 libxslt1.1 libgtk-3-0 libdbus-glib-1-2

# 安装Python依赖
RUN pip install --no-cache-dir -r requirements.txt

# 安装playwright及浏览器
RUN playwright install chromium

# 运行Python脚本
CMD ["python", "ra1.py"]