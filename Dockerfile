# 使用官方Python基础镜像
FROM python:3.9-buster

# 设置工作目录
WORKDIR /app

# 复制依赖文件
COPY requirements.txt .

# 修改debian源并更新apt-get
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y ttf-wqy-microhei libnss3 libx11-xcb1 libasound2 libatk-bridge2.0-0 libgtk-3-0 \
    libxcomposite1 libxdamage1 libxfixes3 libxrandr2 libgbm1 libpango-1.0-0 libcairo2 libxkbcommon0 \
    libxslt1.1 libgtk-3-0 libdbus-glib-1-2 && \
    rm -rf /var/lib/apt/lists/*

# 升级pip并安装Python依赖
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# 设置 Playwright 下载镜像为国内源
ENV PLAYWRIGHT_DOWNLOAD_HOST=https://playwright.azureedge.net

# 安装playwright及浏览器
RUN playwright install chromium

# 复制当前目录内容到工作目录
COPY . .

# 运行Python脚本
CMD ["python", "duckai_service.py"]