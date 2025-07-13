FROM mcr.microsoft.com/devcontainers/python:1-3.12-bullseye
USER root

# Install Puppeteer/Chromium dependencies and Japanese/Emoji fonts
RUN apt-get update && apt-get install -y \
    libx11-xcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxi6 \
    libxrandr2 \
    libasound2 \
    libpangocairo-1.0-0 \
    libatk1.0-0 \
    libgtk-3-0 \
    libgdk-pixbuf2.0-0 \
    libxss1 \
    libgconf-2-4 \
    libgbm-dev \
    libxshmfence1 \
    libnss3 \
    libglib2.0-0 \
    libxtst6 \
    libdrm2 \
    libxfixes3 \
    libxext6 \
    libcairo-gobject2 \
    libcairo2 \
    libpango-1.0-0 \
    fonts-noto-cjk \
    fonts-noto-color-emoji \
    fonts-liberation \
    fonts-dejavu-core \
    fontconfig \
    tmux \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Update font cache
RUN fc-cache -fv
RUN pip install --upgrade pip

# Copy requirements.txt and install Python packages
COPY requirements.txt /tmp/
RUN pip install -r /tmp/requirements.txt

# install yq
RUN curl -LJO https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 \
    && mv yq_linux_amd64 /usr/local/bin/yq \
    && chmod a+x /usr/local/bin/yq
    
COPY ./.tmux.conf /root/