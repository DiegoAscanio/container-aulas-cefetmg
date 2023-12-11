# Usando a imagem que eu criei como base
FROM ubuntu:22.04

# Instalando pacotes necessários
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt install -y python-is-python3 python3-numpy python3-xdg novnc xvfb vim tigervnc-standalone-server openbox libdata-dump-perl xterm wget xz-utils

# Instalando o arduino oriundo do site oficial
RUN wget https://downloads.arduino.cc/arduino-1.8.19-linux64.tar.xz -O /tmp/arduino-1.8.19-linux64.tar.xz
RUN tar -xvf /tmp/arduino-1.8.19-linux64.tar.xz --directory /opt/
RUN rm -rf /tmp/arduino-1.8.19-linux64.tar.xz
RUN /opt/arduino-1.8.19/install.sh
RUN cd /

# Instalando o obmenu-generator e suas dependencias
RUN cd /tmp
RUN wget http://ftp.linux.edu.lv/mxlinux/mx/repo/pool/main/p/perl-linux-desktopfiles/perl-linux-desktopfiles_0.25+git20201209-1~mx21+1_all.deb
RUN wget https://download.opensuse.org/repositories/home:/Head_on_a_Stick:/obmenu-generator/Debian_11/all/obmenu-generator_0.91-1_all.deb
RUN dpkg -i perl-linux-desktopfiles_0.25+git20201209-1~mx21+1_all.deb
RUN dpkg -i obmenu-generator_0.91-1_all.deb
RUN rm -rf *.deb
RUN cd / 

# Gerando um menu dinamico do openbox
RUN mkdir -p /root/.config/openbox
RUN cp -a /etc/xdg/openbox ~/.config/
RUN obmenu-generator -p; exit 0

# Definindo variáveis de ambiente necessárias para o noVNC
ENV DISPLAY=:0

# Linkando o vnc.html para index.html no novnc
RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# Expondo a porta do NOVNC
EXPOSE 6080

# Expondo a porta do VNC
#EXPOSE 5900

# Copiando o startup
COPY startup.sh /startup.sh
RUN chmod 755 /startup.sh

# Limpando o cache do apt
RUN apt install menu -y
RUN apt clean

# Iniciando o X11, o NOVNC e OPENBOX
CMD /startup.sh
