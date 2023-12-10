# Usando a imagem do Arch Linux como base 
FROM archlinux:latest

# Atualizando o repositório de pacotes e instalando os pacotes necessários
RUN pacman-key --init && pacman -Syu --noconfirm
RUN pacman -S base-devel git wget python-numpy python-setuptools bash inetutils unzip --noconfirm
RUN cat /etc/passwd
RUN useradd -u 1000 ninguem -s /bin/bash

# Instalando o websockify
RUN wget https://aur.archlinux.org/cgit/aur.git/snapshot/websockify.tar.gz && \
    tar -xvf websockify.tar.gz && \
    cd websockify && \
    chown -R ninguem . && \
    su ninguem -c "makepkg --noconfirm" && \
    pacman -U *.pkg.tar.zst --noconfirm && \
    cd .. && \
    rm -rf websockify websockify.tar.gz

# Instalando o novnc
RUN wget https://aur.archlinux.org/cgit/aur.git/snapshot/novnc.tar.gz && \
    tar -xvf novnc.tar.gz && \
    cd novnc && \
    chown -R ninguem . && \
    su ninguem -c "makepkg --noconfirm" && \
    pacman -U *.pkg.tar.zst --noconfirm && \
    cd .. && \
    rm -rf novnc novnc.tar.gz

RUN pacman -S --noconfirm \
    tigervnc \
    xorg-server-xvfb \
    xterm \
    supervisor \
    net-tools \
    arduino \
    python-xdg \
    openbox ttf-dejavu ttf-liberation \
    perl perl-data-dump perl-gtk3 \
    vim

# Instalando dependencia do aur perl-linux-desktopfiles
RUN git clone https://aur.archlinux.org/perl-linux-desktopfiles.git /tmp/perl-linux-desktopfiles && \
    cd /tmp/perl-linux-desktopfiles && \
    chown -R ninguem . && \
    su ninguem -c "makepkg --noconfirm" && \
    pacman -U *.pkg.tar.zst --noconfirm && \
    cd .. && \
    rm -rf perl-linux-desktopfiles

# Instalando o obmenu-generator
RUN git clone https://aur.archlinux.org/obmenu-generator.git /tmp/obmenu-generator && \
    cd /tmp/obmenu-generator && \
    chown -R ninguem . && \
    su ninguem -c "makepkg --noconfirm" && \
    pacman -U *.pkg.tar.zst --noconfirm && \
    cd .. && \
    rm -rf obmenu-generator

# Deletando o usuario
RUN userdel ninguem

# Gerando um menu dinamico do openbox
RUN mkdir -p /root/.config/openbox
RUN cp -a /etc/xdg/openbox ~/.config/
RUN obmenu-generator -p -i; exit 0

# Definindo variáveis de ambiente necessárias para o noVNC
ENV DISPLAY=:0

# Linkando o vnc.html para index.html no novnc
RUN ln -s /usr/share/webapps/novnc/vnc.html /usr/share/webapps/novnc/index.html

# Expondo a porta do NOVNC
EXPOSE 6080

# Expondo a porta do VNC
#EXPOSE 5900

# Copiando o startup
COPY startup.sh /startup.sh
RUN chmod 755 /startup.sh

# Iniciando o X11, o NOVNC e OPENBOX
CMD /startup.sh
