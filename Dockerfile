FROM ubuntu
VOLUME /tmp/.X11-unix
RUN apt update \
 && DEBIAN_FRONTEND=noninteractive apt install -y wget gnupg xvfb x11-xserver-utils python3-pip inotify-tools \
 # pulseaudio
 lxterminal \
 && pip3 install pyinotify \
 && echo "deb [arch=amd64] https://xpra.org/ focal main" > /etc/apt/sources.list.d/xpra.list \
 && wget -q https://xpra.org/gpg.asc -O- | apt-key add - \
 && apt update \
 && DEBIAN_FRONTEND=noninteractive apt install -y xpra=4.0.6-r28351-1 \
 && mkdir -p /run/user/0/xpra


 #Ultimaker Cura
RUN wget https://software.ultimaker.com/cura/Ultimaker_Cura-4.10.0.AppImage
RUN chmod +x /Ultimaker_Cura-4.10.0.AppImage


ENV APPIMAGE_EXTRACT_AND_RUN=1
ENV NO_CLEANUP=1

RUN mkdir /root/gcode
COPY DownloadWatcher.sh /root/gcode
RUN chmod +x /root/gcode/DownloadWatcher.sh

COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["xpra", "start", ":80", "--bind-tcp=0.0.0.0:8080", \
 "--mdns=no", "--webcam=no", "--no-daemon", \
 "--start-on-connect=lxterminal", \
 "--start=/start.sh"]
