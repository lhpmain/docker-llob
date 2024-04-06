FROM flyqie/docker-novnc:latest

# 换源
RUN sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list
RUN sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

COPY ./docker-root /

RUN chown root:root /tmp && \
	chmod 1777 /tmp && \
	apt-get update && \
	apt-get install -y language-pack-zh-hans tzdata fontconfig fonts-wqy-zenhei && \
	apt-get install -y --no-install-recommends fcitx fcitx-ui-classic fcitx-pinyin && \
	apt-get install -y \
		dbus-user-session libgtk-3-0 libnotify4 libnss3 libxss1 \
		libxtst6 xdg-utils libatspi2.0-0 libuuid1 libsecret-1-0 \
		libasound2 gnutls-bin libgbm1 ffmpeg

RUN arch=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) && \
	wget -O /tmp/linux_qq.deb https://dldir1.qq.com/qqfile/qq/QQNT/Linux/QQ_3.2.6_240322_${arch}_01.deb

RUN wget -O /tmp/LiteLoaderQQNT.zip https://github.com/LiteLoaderQQNT/LiteLoaderQQNT/releases/download/1.0.3/LiteLoaderQQNT.zip && \
	wget -O /tmp/LLOneBot.zip https://github.com/LLOneBot/LLOneBot/releases/download/v3.20.7/LLOneBot.zip

RUN chsh -s /bin/bash user && \
	mkdir -p /home/user/.fonts/ && \
	chown -R user:user /home/user && \
	su user -c 'fc-cache -v'

RUN apt-get autoremove -y && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists

ENV LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8 \
    TZ=Asia/Shanghai

# QQ应用
VOLUME ["/opt/QQ"]

# QQ用户配置
VOLUME ["/home/user/.config/QQ"]
