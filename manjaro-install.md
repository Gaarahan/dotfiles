## 装机指南  majaro-kde

### 辅助工具
1. kde-connect,剪贴板辅助及文件传输在新电脑没有外网权限时很有用

### 网络配置
1. 目前用的是clash，配置思路来自：
https://akillcool.github.io/post/clash-with-auto-update-config/

### 更新镜像源
- 使用 pacman-mirrors 工具更新 -c 指定国家，-f 以速度排序

### package manager - yay
- pacman -S yay
- edit /etc/pacman.conf, remove the comment of Color

### 输入法
1. 装了fctix包，但对应的配置需要kde-config-fcitx包才能正常工作
2. 安装fcitx-googlepinyin
3. 安装了中文字体adobe-source-han-sans-cn-font
4. 通过 `~/.pam_environment` 设置环境变量，pam-env 模块会在所有登录会话中读取此文件，包括 X11 会话和 Wayland 会话
```
GTK_IM_MODULE DEFAULT=fcitx
QT_IM_MODULE  DEFAULT=fcitx
XMODIFIERS    DEFAULT=\@im=fcitx
```

### font
- ttf-monaco - for terminal
- adobe-source-han-sans-cn-font - for input method

### 配置终端
- install tmux // TODO config
- install zsh & oh my zsh 
	 - chsh -s /bin/zsh

- config the `2*2 virtual-desktop`

### git
- ssh:  ssh-keygen -t ed25519 -C "gaarahan@foxmail.com"
- proxy:
```bash
    git config --global http.proxy 'socks5://127.0.0.1:7891'
```

### vim
- nvim, py2, py3
- neovim module : pip2/pip3 install neovim
- nvm, npm, node
- vim-plug

### Tools
- telegram-desktop
- google-chrome
	遇到报错: Error: ==> ERROR: Cannot find the fakeroot binary.
	yay -S base-devel
- vscode
- java
- webstorm webstorm-jre
- flameshot
